import 'package:get/get.dart';

class ExchangeParticipant {
  late final int id;
  late final String fullName;
  late final String source;
  late final String email;
  late final String phoneNumber;
  late final String university;
  late final String fieldOfStudy;
  late final String dateOfBirth;
  late final int expaEPID;
  late final String allocatedDepartment;
  late final String memberName;
  late final String offlineStatus;
  late final String status;
  late final String cvLink;
  late final RxBool isContacted;
  late final RxBool isInterested;
  late final String trackingPhase;
  late final String notes;
  late final String communicationChannel;
  late final String product;
  late final String field;
  late final String availability;

  ExchangeParticipant.fromJson(Map data, this.id) {
    fullName = data['Full Name'];
    source = data['Source'];
    email = data['Email(s)'];
    phoneNumber = data['Phone Number(s)'];
    university = data['University'];
    fieldOfStudy = data['Field Of Study'];
    dateOfBirth = data['DOB'];

    if ((data['EP ID'] as String).isNotEmpty && (data['EP ID'] as String) != '-') {
      expaEPID = int.parse(data['EP ID']);
    } else {
      expaEPID = -1;
    }

    allocatedDepartment = data['Allocate the departement'];
    if ((data['Member Name'] as String).isNotEmpty) {
      memberName = data['Member Name'];
    } else {
      memberName = "None";
    }

    offlineStatus = data["Status if it's still offline (you can modify this)"];
    status = (data['Status on expa'] as String).isEmpty ? "Stranger" : data['Status on expa'];
    cvLink = data['CV'];
    isContacted = RxBool(data['Contacted'] == "TRUE");
    isInterested = RxBool(data['Interested'] == "TRUE");
    trackingPhase = data.containsKey("Tracking Phase") ? data['Tracking Phase'] : "-";
    notes = data.containsKey('Notes') ? data['Notes'] : "-";
    communicationChannel =
        data.containsKey('Communication channel') ? data['Communication channel'] : "-";
    if (data.containsKey("Product")) {
      product = data['Product'];
    } else {
      product = "-";
    }
    field = data.containsKey("Sub-Product") ? data['Sub-Product'] : "-";
    availability = data.containsKey("Availability") ? data['Availability'] : "-";
  }
}
