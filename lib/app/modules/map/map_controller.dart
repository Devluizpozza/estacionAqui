// ignore_for_file: depend_on_referenced_packages

import 'package:estacionaqui/app/consts/enums.dart';
import 'package:estacionaqui/app/db/collections.dart';
import 'package:estacionaqui/app/db/db.dart';
import 'package:estacionaqui/app/handlers/bottom_sheet_handler.dart';
import 'package:estacionaqui/app/models/app_user_model.dart';
import 'package:estacionaqui/app/models/follower.dart';
import 'package:estacionaqui/app/models/parking_model.dart';
import 'package:estacionaqui/app/models/ticket_model.dart';
import 'package:estacionaqui/app/modules/user/user_controller.dart';
import 'package:estacionaqui/app/repositories/app_user_repository.dart';
import 'package:estacionaqui/app/repositories/follower_repository.dart';
import 'package:estacionaqui/app/repositories/parking_repository.dart';
import 'package:estacionaqui/app/repositories/ticket_repository.dart';
import 'package:estacionaqui/app/routes/app_routes.dart';
import 'package:estacionaqui/app/utils/app_colors.dart';
import 'package:estacionaqui/app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapToViewController extends GetxController {
  final Rxn<LatLng> currentPosition = Rxn<LatLng>();
  final RxBool _isLoading = false.obs;
  final Rx<List<Marker>> _markers = Rx<List<Marker>>(<Marker>[]);
  final ParkingRepository parkingRepository = ParkingRepository();
  final FollowerRepository followerRepository = FollowerRepository();
  final AppUserRepository userRepository = AppUserRepository();
  final TicketRepository ticketRepository = TicketRepository();
  final RxMap<String, bool> followingStatus = <String, bool>{}.obs;

  String get userUID => UserController.instance.user!.uid;

  bool get isLoading => _isLoading.value;

  set isLoading(bool value) {
    _isLoading.value = value;
    _isLoading.refresh();
  }

  List<Marker> get markers => _markers.value;

  set markers(List<Marker> value) {
    _markers.value = value;
    _markers.refresh();
  }

  @override
  void onInit() async {
    isLoading = true;
    Future.delayed(Duration(seconds: 4));
    await detectLocation();
    await setMarker();
    super.onInit();
    isLoading = false;
  }

  Future<List<Ticket>> listTicketsByParking(String parkingUID) async {
    try {
      List<Ticket> tickets = await ticketRepository.list(parkingUID);
      if (tickets.isNotEmpty) {
        return tickets;
      }
      return [];
    } catch (e) {
      Logger.info(e.toString());
      return [];
    }
  }

  Future<void> detectLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        return;
      }
    }
    Position position = await Geolocator.getCurrentPosition();
    currentPosition.value = LatLng(position.latitude, position.longitude);
  }

  Future<void> checkIfFollowing(String parkingUID) async {
    try {
      final followers = await followerRepository.listFollowers(parkingUID);
      final isFollowing = followers.any(
        (follower) => follower.userUID == userUID,
      );
      followingStatus[parkingUID] = isFollowing;
      followingStatus.refresh();
    } catch (e) {
      Logger.info('Erro ao verificar se segue: $e');
    }
  }

  Future<void> handleFollow(String parkingUID) async {
    try {
      AppUser user = await userRepository.fetch(userUID);
      List<Follower> remoteFollower = await followerRepository.listFollowers(
        parkingUID,
      );
      Follower? meFollow = remoteFollower.firstWhereOrNull(
        (e) => e.userUID == userUID,
      );
      if (meFollow == null) {
        Follower followerToSave = Follower(
          uid: DB.generateUID(Collections.follower),
          userUID: userUID,
          userName: user.name,
          createAt: DateTime.now(),
        );
        await followerRepository.createFollower(parkingUID, followerToSave);
      } else {
        await followerRepository.removeFollower(parkingUID, userUID);
      }
      await checkIfFollowing(parkingUID);
    } catch (e) {
      Logger.info(e.toString());
    }
  }

  Future<void> setMarker() async {
    try {
      final List<Parking> remoteParkings = await parkingRepository.list();
      if (remoteParkings.isNotEmpty) {
        for (Parking remoteParking in remoteParkings) {
          List<Ticket> ticketsByParking = await listTicketsByParking(
            remoteParking.uid,
          );
          List<Ticket>? slotsOccupedToFilter =
              ticketsByParking
                  .where((ticket) => ticket.statusType == StatusType.active)
                  .toList();
          int slotsOccuped = slotsOccupedToFilter.length;
          Marker markerToSave = Marker(
            point: LatLng(
              remoteParking.place.geolocationPoint.latitude,
              remoteParking.place.geolocationPoint.longitude,
            ),
            width: 250, // adicione largura
            height: 100,
            child: GestureDetector(
              onTap: () {
                BottomSheetHandler.showSimpleBottomSheet(
                  Get.context!,
                  buildParkingBottomSheet(remoteParking),
                  initialChildSize: 0.5,
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 6,
                child: Container(
                  width: 250,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              remoteParking.displayName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "$slotsOccuped/${remoteParking.slots}",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "vagas",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );

          markers.add(markerToSave);
        }
      }
    } catch (e) {
      Logger.info(e.toString());
    }
  }

  void showUnfollowOptions(String parkingUID) {
    BottomSheetHandler.showConfirmationBottomSheet(
      context: Get.context!,
      title: "Deseja deixar de seguir?",
      confirmText: "Deixar de seguir",
      confirmColor: Colors.red,
      onCancel: () => Get.back(),
      onConfirm: () async {
        await handleFollow(parkingUID);
      },
    );
  }

  Widget buildParkingBottomSheet(Parking parking) {
    checkIfFollowing(parking.uid);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(
            "https://unsplash.com/pt-br/ilustra%C3%A7%C3%B5es/homem-em-oculos-vr-virtual-realidade-metaverso-conceito-de-tecnologias-de-inteligencia-artificial-ilustracao-vetorial-moderna-MVdQKxe_YTg",
          ),
        ),
        const SizedBox(height: 16),

        Text(
          parking.displayName,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Obx(() {
                final isFollowing = followingStatus[parking.uid] ?? false;
                return ElevatedButton(
                  onPressed: () {
                    if (isFollowing) {
                      showUnfollowOptions(parking.uid);
                    } else {
                      handleFollow(parking.uid);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFollowing ? Colors.green : Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    isFollowing ? "Seguindo" : "Seguir",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                );
              }),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.toNamed(
                    AppRoutes.parking_detail,
                    arguments: {"parking": parking},
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Ir para página",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // ignore: avoid_unnecessary_containers
        Container(
          child: Text(
            parking.description,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              parking.comforts.map((comfort) {
                return Chip(
                  label: Text(
                    comfort,
                    style: const TextStyle(color: Colors.deepPurpleAccent),
                  ),
                  backgroundColor: AppColors.lightGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
