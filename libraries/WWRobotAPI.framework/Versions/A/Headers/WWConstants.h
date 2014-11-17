//
//  WWConstants.h
//  APIObjectiveC
//
//  Created by Orion Elenzil on 20140918.
//  Copyright (c) 2014 Wonder Workshop inc. (https://www.makewonder.com/) All rights reserved.
//

#ifndef APIObjectiveC_WWConstants_h
#define APIObjectiveC_WWConstants_h

// todo: convert into typedef, as well as making everything to be #define
// hide others in WWConstants_Internal.h

/** number constant definitions **/

// max/min boundaries
#define WW_LIGHT_BRIGHTNESS_MAX 1.0
#define WW_LIGHT_BRIGHTNESS_MIN 0.0
#define WW_VOLUME_MAX 1.0
#define WW_VOLUME_MUTE 0.0
#define WW_VOULUME_UNDEFINED 1.1

// sound file syntax definitions
#define WW_SOUND_DIR_LENGTH 4
#define WW_SOUND_FILE_MIN_LENGTH 1
#define WW_SOUND_FILE_MAX_LENGTH 10

// defines for componentIds (used for CommandSet and SensorSet)
typedef unsigned int WWComponentId;
#define WW_COMMAND_POWER 1
#define WW_COMMAND_EYE_RING 100
#define WW_COMMAND_LIGHT_RGB_EYE 101
#define WW_COMMAND_LIGHT_RGB_LEFT_EAR 102
#define WW_COMMAND_LIGHT_RGB_RIGHT_EAR 103
#define WW_COMMAND_LIGHT_RGB_CHEST 104
#define WW_COMMAND_LIGHT_MONO_TAIL 105
#define WW_COMMAND_LIGHT_MONO_BUTTON_MAIN 106
#define WW_COMMAND_HEAD_POSITION_TILT 202
#define WW_COMMAND_HEAD_POSITION_PAN 203
#define WW_COMMAND_BODY_LINEAR_ANGULAR 204
#define WW_COMMAND_BODY_WHEELS 211
#define WW_COMMAND_MOTOR_HEAD_BANG 210
#define WW_COMMAND_SPEAKER 300
#define WW_SENSOR_BUTTON_MAIN 1000
#define WW_SENSOR_BUTTON_1 1001
#define WW_SENSOR_BUTTON_2 1002
#define WW_SENSOR_BUTTON_3 1003
#define WW_SENSOR_HEAD_POSITION_PAN 2000
#define WW_SENSOR_HEAD_POSITION_TILT 2001
#define WW_SENSOR_ACCELEROMETER 2003
#define WW_SENSOR_GYROSCOPE 2004
#define WW_SENSOR_DISTANCE_FRONT_LEFT_FACING 3000
#define WW_SENSOR_DISTANCE_FRONT_RIGHT_FACING 3001
#define WW_SENSOR_DISTANCE_BACK 3002
#define WW_SENSOR_ENCODER_LEFT_WHEEL 3003
#define WW_SENSOR_ENCODER_RIGHT_WHEEL 3004
#define WW_SENSOR_MICROPHONE 3005

typedef unsigned int WWRobotType;
#define WW_ROBOT_UNKNOWN 1000
#define WW_ROBOT_DASH 1001
#define WW_ROBOT_DOT 1002

typedef unsigned int WWPersonalityColorIndex;
#define WW_PERSONALITY_COLOR_NONE 0
#define WW_PERSONALITY_COLOR_YELLOW 1
#define WW_PERSONALITY_COLOR_GREEN 2
#define WW_PERSONALITY_COLOR_ORANGE 3
#define WW_PERSONALITY_COLOR_BLUE 4
#define WW_PERSONALITY_COLOR_RED 5
#define WW_PERSONALITY_COLOR_PURPLE 6
#define WW_PERSONALITY_COLOR_INVALID 255

typedef unsigned int WWPersonalityAnimationIndex;
#define WW_PERSONALITY_ANIMATION_NONE 0
#define WW_PERSONALITY_ANIMATION_1 1
#define WW_PERSONALITY_ANIMATION_2 2
#define WW_PERSONALITY_ANIMATION_3 3
#define WW_PERSONALITY_ANIMATION_INVALID 255


#define ROBOT_NAME_SIZE 18

/** string constant definitions **/
#if __OBJC__
#define __wwstr__ @
#else
#define __wwstr__
#endif

#define WW_SOUND_SYSTEM_DIR             __wwstr__"SYST"

#undef wwstr

#endif