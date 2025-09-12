// ignore_for_file: non_constant_identifier_names, constant_identifier_names
class ErrorCode {
  static const int LINK_ERR_OK = 0;
  static const int LINK_ERR_UNDEFINE = 9999;
  static const int LINK_ERR_PARAM_ERROR = 10000;
  static const int LINK_ERR_FILE_OPEN_FAILED = 10001;
  static const int LINK_ERR_FILE_READ_FAILED = 10002;
  static const int LINK_ERR_FILE_WRITE_FAILED = 10003;
  static const int LINK_ERR_NO_MEMORY = 10100;
  static const int LINK_ERR_THREAD = 10200;
  static const int LINK_ERR_NET_MISS = 10300;
  static const int LINK_ERR_NET_BUSY = 10301;
  static const int LINK_ERR_NET_CANCEL = 10302;
  static const int LINK_ERR_NET_TIMEOUT = 10303;
  static const int LINK_ERR_NET_OTHER = 10304;
  static const int LINK_ERR_PARSE_XML = 10400;
  static const int LINK_ERR_PARSE_FIELD_MISS = 10401;
  static const int LINK_ERR_PARSE_ERR_CONTENT = 10402;
  static const int LINK_ERR_NOT_INIT = 10500;
  static const int LINK_ERR_AUTH_FAIL = 10600;
  static const int LINK_ERR_AUTH_NO_PERMIT = 10601;
  static const int LINK_ERR_AUTH_NO_TIMES = 10602;
  static const int LINK_ERR_NOT_CONNECT = 10700;
  static const int LINK_ERR_PROTOCOL_INTERNAL_MISS = 10800;
  static const int LINK_ERR_PROTOCOL_UNKNOWN = 10801;
  static const int LINK_ERR_PROTOCOL_NOT_ADAPT = 10802;
  static const int LINK_ERR_PROTOCOL_UNEXPECTED_CALL = 10803;
  static const int LINK_ERR_PROTOCOL_DEVICE_NOT_ADAPT = 10804;
  static const int LINK_ERR_PROTOCOL_NO_PERMIT = 10805;
  static const int LINK_ERR_CACHE_MENU_MISS = 10900;
  static const int LINK_ERR_CACHE_MENU_EXIST = 10901;
  static const int LINK_ERR_CACHE_FILE_MISS = 10902;
  static const int LINK_ERR_MENU_UPGRADE = 10903;
  static const int LINK_ERR_MENU_DISABLED = 10904;
}

class StateCode {
  static const int LINK_STATE_OK = 0;
  static const int LINK_STATE_FILE_NOT_EXIST = -1;
  static const int LINK_STATE_FILE_NO_EXIF = -2;
  static const int LINK_STATE_FILE_READ_ONLY = -3;
  static const int LINK_STATE_FILE_ERROR = -4;
  static const int LINK_STATE_FILE_DELETE_FAIL = -5;
  static const int LINK_STATE_FILE_WR_ERROR = -6;
  static const int LINK_STATE_STORAGE_NONE = -7;
  static const int LINK_STATE_STORAGE_ERROR = -8;
  static const int LINK_STATE_STORAGE_FULL = -9;
  static const int LINK_STATE_STORAGE_SLOW = -10;
  static const int LINK_STATE_FW_READ_ERROR = -11;
  static const int LINK_STATE_FW_WRITE_ERROR = -12;
  static const int LINK_STATE_FW_STORAGE_ERROR = -13;
  static const int LINK_STATE_FW_UPGRADE_ERROR = -14;
  static const int LINK_STATE_NO_MEMORY = -15;
  static const int LINK_STATE_PARAM_ERROR = -16;
  static const int LINK_STATE_BATTERY_LOW = -17;
  static const int LINK_STATE_ILLEGAL_STATE = -18;
  static const int LINK_STATE_EXECUTE_FAIL = -19;
  static const int LINK_STATE_UNKNOWN_PROTOCOL = -20;
  static const int LINK_STATE_ACCESS_REFUSED = -21;
  static const int LINK_STATE_UNDEFINE = -99;
}

class Command {
  static const int LINK_CMD_UNDEFINE = 0;
  static const int LINK_CMD_PRE_RECORDING = 1000;
  static const int LINK_CMD_VIDEO_LOOP_REC = 1001;
  static const int LINK_CMD_VIDEO_RESOLUTION = 1002;
  static const int LINK_CMD_AUTO_VIDEO_REC = 1003;
  static const int LINK_CMD_MOTION_DETECT = 1004;
  static const int LINK_CMD_PARKING_GUARD = 1005;
  static const int LINK_CMD_GSENSOR_SENSITIVITY = 1006;
  static const int LINK_CMD_MIC = 1007;
  static const int LINK_CMD_HDR = 1008;
  static const int LINK_CMD_PIP_SINGLE_LENS = 1009;
  static const int LINK_CMD_VIDEO_COLOR = 1010;
  static const int LINK_CMD_ZOOM_INOUT = 1011;
  static const int LINK_CMD_IR_LED = 1012;
  static const int LINK_CMD_DATE_LOGO = 1013;
  static const int LINK_CMD_PIP_MULTIPLE_LENS = 1014;
  static const int LINK_CMD_SLOW_MOTION_REC = 1015;
  static const int LINK_CMD_TIMELAPSE_REC = 1016;
  static const int LINK_CMD_TIMELAPSE_REC_FPS = 1017;
  static const int LINK_CMD_TIMELAPSE_REC_DURATION = 1018;
  static const int LINK_CMD_WDR = 1019;
  static const int LINK_CMD_VIDEO_CODEC_TYPE = 1020;
  static const int LINK_CMD_FLIP = 1021;
  static const int LINK_CMD_MIRROR = 1022;
  static const int LINK_CMD_LDC = 1023;
  static const int LINK_CMD_DIS = 1024;
  static const int LINK_CMD_MOVIE_FORMAT = 1025;
  static const int LINK_CMD_ADAS = 1026;
  static const int LINK_CMD_PHOTO_RESOLUTION = 2000;
  static const int LINK_CMD_TIMER_PHOTO = 2001;
  static const int LINK_CMD_BURST = 2002;
  static const int LINK_CMD_PHOTO_QUALITY = 2003;
  static const int LINK_CMD_PHOTO_COLOR = 2004;
  static const int LINK_CMD_PHOTO_DATE_STAMP = 2005;
  static const int LINK_CMD_EV = 3000;
  static const int LINK_CMD_WHITE_BALANCE = 3001;
  static const int LINK_CMD_SHARPNESS = 3002;
  static const int LINK_CMD_ISO = 3003;
  static const int LINK_CMD_BRIGHTNESS = 4000;
  static const int LINK_CMD_VOLUME = 4001;
  static const int LINK_CMD_AI_BRAIN = 4002;
  static const int LINK_CMD_TV_FORMAT = 4003;
  static const int LINK_CMD_KEY_TONE = 4004;
  static const int LINK_CMD_LANGUAGE = 4005;
  static const int LINK_CMD_GPS_SPEED_UNIT = 4006;
  static const int LINK_CMD_FLICKER = 4007;
  static const int LINK_CMD_GYROSCOPE = 4008;
  static const int LINK_CMD_INTERNAL_STORAGE_SPACE = 4009;
  static const int LINK_CMD_EXTERNAL_STORAGE_SPACE = 4010;
  static const int LINK_CMD_FORMAT_INTERNAL_STORAGE = 4011;
  static const int LINK_CMD_FORMAT_EXTERNAL_STORAGE = 4012;
  static const int LINK_CMD_BLE_FREE_CONNECT = 4013;
  static const int LINK_CMD_WIFI_SSID = 4014;
  static const int LINK_CMD_WIFI_PASSWORD = 4015;
  static const int LINK_CMD_BOOT_SOUND = 4016;
  static const int LINK_CMD_SCREEN_OFF_DELAY = 4017;
  static const int LINK_CMD_POWER_OFF = 4018;
  static const int LINK_CMD_USB_MODE = 4019;
  static const int LINK_CMD_DELAY_POWER_OFF = 4021;
  static const int LINK_CMD_WIFI_BAND = 4022;
  static const int LINK_CMD_SYSTEM_RESET = 4023;
  static const int LINK_CMD_VERSION = 4024;
  static const int LINK_CMD_PIR_INTERVAL = 4025;
  static const int LINK_CMD_PIR_MONITORING_PERIOD = 4026;
  static const int LINK_CMD_PIR_MONITORING_PERIOD_TIME = 4027;
  static const int LINK_CMD_HUNTING_MODE = 4028;
  static const int LINK_CMD_EDOG_SOUND = 4029;
  static const int LINK_CMD_FORMAT_REMIND = 4030;
  static const int LINK_CMD_EDOG_VERSION = 4031;
  static const int LINK_CMD_TIMEZONE = 4032;
  static const int LINK_CMD_EDOG = 4033;
  static const int LINK_CMD_EDOG_ICON = 4034;
  static const int LINK_CMD_EDOG_VOLUME = 4035;
  static const int LINK_CMD_EDOG_OVERSPEED = 4036;
  static const int LINK_CMD_MCU_VERSION = 4037;
  static const int LINK_CMD_F_SENSOR_VERSION = 4038;
  static const int LINK_CMD_R_SENSOR_VERSION = 4039;
}

class CommandType {
 static const int LINK_CMD_TYPE_NORMAL = 1;
 static const int LINK_CMD_TYPE_EDITABLE = 2;
 static const int LINK_CMD_TYPE_MULTIPLE_CHOICE = 4;
}

class CommandGroup {
  static const int LINK_CMD_GROUP_MOVIE = 1;
  static const int LINK_CMD_GROUP_PHOTO = 2;
  static const int LINK_CMD_GROUP_IQ = 3;
  static const int LINK_CMD_GROUP_DEVICE = 4;
}

class NotifyCode {
  static const int LINK_NOTIFY_UNDEFINE = -1;
  static const int LINK_NOTIFY_REC_STARTED = 100;
  static const int LINK_NOTIFY_REC_STOPPED = 101;
  static const int LINK_NOTIFY_REC_LOCKED = 102;
  static const int LINK_NOTIFY_REC_UNLOCKED = 103;
  static const int LINK_NOTIFY_REC_TIME_RESET = 104;
  static const int LINK_NOTIFY_DO_CAPTURE = 105;
  static const int LINK_NOTIFY_MIC_ON = 106;
  static const int LINK_NOTIFY_MIC_OFF = 107;
  static const int LINK_NOTIFY_MOVIE_WR_ERROR = 108;
  static const int LINK_NOTIFY_CARD_INSERT = 109;
  static const int LINK_NOTIFY_CARD_REMOVE = 110;
  static const int LINK_NOTIFY_CARD_SLOW = 111;
  static const int LINK_NOTIFY_CARD_FULL = 112;
  static const int LINK_NOTIFY_PIP_STYLE_CHANGED = 113;
  static const int LINK_NOTIFY_PARKING_GUARD_ON = 114;
  static const int LINK_NOTIFY_PARKING_GUARD_OFF = 115;
  static const int LINK_NOTIFY_VIDEO_MODE = 116;
  static const int LINK_NOTIFY_PHOTO_MODE = 117;
  static const int LINK_NOTIFY_PLAYBACK_MODE = 118;
  static const int LINK_NOTIFY_WILL_CHANGE_MODE = 119;
  static const int LINK_NOTIFY_NEW_USER = 120;
  static const int LINK_NOTIFY_WIFI_DISCONNECT = 121;
  static const int LINK_NOTIFY_BATTERY_CHANGE = 122;
  static const int LINK_NOTIFY_SYSTEM_RESET = 123;
  static const int LINK_NOTIFY_POWER_OFF = 124;
  static const int LINK_NOTIFY_CAPTURE_SUCCESS = 125;
}

class StorageType {
  static const int LINK_STORAGE_INTERNAL = 0;
  static const int LINK_STORAGE_EXTERNAL = 1;
}

class WorkMode {
  static const int LINK_WORKMODE_PHOTO = 0;
  static const int LINK_WORKMODE_VIDEO = 1;
  static const int LINK_WORKMODE_PLAYBACK = 2;
}

class StorageState {
  static const int LINK_CARD_OK = 0;
  static const int LINK_CARD_REMOVED = 1;
  static const int LINK_CARD_FULL = 2;
  static const int LINK_CARD_READ_ONLY = 3;
  static const int LINK_CARD_LOCKED = 4;
  static const int LINK_CARD_UNFORMATTED = 5;
  static const int LINK_CARD_UNKNOWN_FORMAT = 6;
  static const int LINK_CARD_BAD = 7;
  static const int LINK_CARD_ERROR = 8;
}

class BatteryState {
  static const int LINK_BATTERY_FULL = 0;
  static const int LINK_BATTERY_MED = 1;
  static const int LINK_BATTERY_LOW = 2;
  static const int LINK_BATTERY_EMPTY = 3;
  static const int LINK_BATTERY_EXHAUSTED = 4;
  static const int LINK_BATTERY_CHARGE = 5;
  static const int LINK_BATTERY_NONE = 6;
}

class BoolState {
  static const int LINK_BOOL_STATE_OFF = 0;
  static const int LINK_BOOL_STATE_ON = 1;
}

class FileCopyState {
  static const int LINK_FILE_COPY_NONE = 0;
  static const int LINK_FILE_COPY_ON = 1;
  static const int LINK_FILE_COPY_EXECUTING = 2;
}

class DirType {
  static const int LINK_DIR_PHOTO = 0;
  static const int LINK_DIR_VIDEO = 1;
  static const int LINK_DIR_EVENT = 2;
}

class SoftwareType {
  static const int LINK_SOFTWARE_FW = 1;
  static const int LINK_SOFTWARE_EDOG = 2;
  static const int LINK_SOFTWARE_MCU = 4;
  static const int LINK_SOFTWARE_F_SENSOR = 8;
  static const int LINK_SOFTWARE_R_SENSOR = 16;
}

class Capability {
  static const int LINK_CAP_PHOTO_MODE = 0;
  static const int LINK_CAP_MULTIPLE_STORAGE = 1;
  static const int LINK_CAP_STORAGE_SWITCH = 2;
  static const int LINK_CAP_EXTERNAL_STORAGE_SPACE = 3;
  static const int LINK_CAP_FORMAT_INTERNAL_STORAGE = 4;
  static const int LINK_CAP_GPS_IN_FILE = 7;
  static const int LINK_CAP_DISPLAY_RT_TRACK = 8;
  static const int LINK_CAP_VIDEO_REC = 9;
  static const int LINK_CAP_REC_TIME = 10;
}

class ConnectionType {
  static const int LINK_CONNECTION_TYPE_NONE = 0;
  static const int LINK_CONNECTION_TYPE_WIFI = 1;
  static const int LINK_CONNECTION_TYPE_4G = 2;
  static const int LINK_CONNECTION_TYPE_ALL = 3;
}

class ConnectionState {
  static const int LINK_CONNECTION_STATE_NONE = 0;
  static const int LINK_CONNECTION_STATE_CONNECTING = 1;
  static const int LINK_CONNECTION_STATE_CONNECTED = 2;
}