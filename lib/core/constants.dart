class Constants {
  //Collections
  static const String FIRESTORE_COL_CUSTOMERS = 'customers';
  static const String FIRESTORE_COL_OPERATION_DRAFTS = 'drafts';
  static const String FIRESTORE_COL_OPERATIONS = 'operations';
  static const String FIRESTORE_COL_PATIENTS = 'patients';
  static const String FIRESTORE_COL_DOCTORS = 'doctors';
  static const String FIRESTORE_COL_HOSPITALS = 'hospitals';
  static const String FIRESTORE_COL_OPERATION_ROOMS = 'operation_rooms';
  static const String FIRESTORE_COL_DEPARTMENTS = 'departments';
  static const String FIRESTORE_COL_DOCTOR_OPERATIONS = 'doctor_operations';
  static const String FIRESTORE_COL_VERIFICATION_REQUESTS =
      'verificationRequests';

  //Documents
  static const String FIRESTORE_DOC_ORNEK_BELGE = '';

  //Fields
  //Customer Fields
  static const String FIRESTORE_FIELD_CUSTOMER_ID = 'id';
  static const String FIRESTORE_FIELD_CUSTOMER_NAME = 'name';
  //Department Fields
  static const String FIRESTORE_FIELD_DEPARTMENT_ID = 'id';
  static const String FIRESTORE_FIELD_DEPARMENT_NAME = 'name';
  //Doctor Fields
  static const String FIRESTORE_FIELD_DOCTOR_ID = 'id';
  static const String FIRESTORE_FIELD_DOCTOR_NAME = 'name';
  static const String FIRESTORE_FIELD_DOCTOR_SURNAME = 'surname';
  static const String FIRESTORE_FIELD_DOCTOR_PHONE = 'phone';
  static const String FIRESTORE_FIELD_DOCTOR_EMAIL = 'email';
  static const String FIRESTORE_FIELD_DOCTOR_GRADE = 'grade';
  static const String FIRESTORE_FIELD_DOCTOR_DEPARTMENTID = 'department_id';
  static const String FIRESTORE_FIELD_DOCTOR_CUSTOMERID = 'customer_id';
  static const String FIRESTORE_FIELD_DOCTOR_IS_VERIFIED = 'is_verified';
  //Hospital Fields
  static const String FIRESTORE_FIELD_HOSPITAL_ID = 'id';
  static const String FIRESTORE_FIELD_HOSPITAL_NAME = 'name';
  static const String FIRESTORE_FIELD_HOSPITAL_CUSTOMERID = 'customer_id';
  //Operation Fields
  static const String FIRESTORE_FIELD_OPERATION_ROOMID = 'room_id';
  static const String FIRESTORE_FIELD_OPERATION_HOSPITALID = 'hospital_id';
  static const String FIRESTORE_FIELD_OPERATION_DATE = 'date';
  static const String FIRESTORE_FIELD_OPERATION_DEPARTMENTID = 'department_id';
  static const String FIRESTORE_FIELD_OPERATION_DOCTOR_IDS = 'doctor_ids';
  //Operation_draft Fields
  static const String FIRESTORE_FIELD_OPERATION_DRAFT_ID = 'id';
  static const String FIRESTORE_FIELD_OPERATION_DRAFT_PATIENTID = 'patient_id';
  static const String FIRESTORE_FIELD_OPERATION_DRAFT_PRIORITY = 'priority';
  static const String FIRESTORE_FIELD_OPERATION_STATUS = 'status';
  static const String FIRESTORE_FIELD_OPERATION_DRAFT_DESCRIPTION =
      'description';
  static const String FIRESTORE_FIELD_OPERATION_DRAFT_CUSTOMERID =
      'customer_id';
  //Operation_room Fields
  static const String FIRESTORE_FIELD_OPERATION_ROOM_ID = 'id';
  static const String FIRESTORE_FIELD_OPERATION_ROOM_NAME = 'name';
  static const String FIRESTORE_FIELD_OPERATION_ROOM_HOSPITALID = 'hospital_id';
  //Patient Fields
  static const String FIRESTORE_FIELD_PATIENT_ID = 'id';
  static const String FIRESTORE_FIELD_PATIENT_NAME = 'name';
  static const String FIRESTORE_FIELD_PATIENT_PHONE = 'phone';

  //Values
  static const int FIRESTORE_VALUE_PRIORITY_LOW = 2;
  static const int FIRESTORE_VALUE_PRIORITY_NORMAL = 1;
  static const int FIRESTORE_VALUE_PRIORITY_HIGH = 0;

  static const int FIRESTORE_VALUE_STATUS_DONE = 2;
  static const int FIRESTORE_VALUE_STATUS_ACTIVE = 1;
  static const int FIRESTORE_VALUE_STATUS_DELETED = 3;

  static const String TEST_CUSTOMER_ID = 'testcustomer';
}
