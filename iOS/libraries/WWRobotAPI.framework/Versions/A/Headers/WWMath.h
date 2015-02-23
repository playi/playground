//
//  WWMath.h
//  APIObjectiveC
//
//  Created by Orion Elenzil on 20140930.
//  Copyright (c) 2014 Wonder Workshop inc. (https://www.makewonder.com/) All rights reserved.
//

#ifndef APIObjectiveC_WWMath_h
#define APIObjectiveC_WWMath_h

#include <math.h>

#ifdef __cplusplus
extern "C" {
#endif
    
    
    
#define WW_TWO_PI        (M_PI * 2.0)
#define WW_DEG_TO_RAD(X) (X * WW_TWO_PI / 360.0)
#define WW_RAD_TO_DEG(X) (X / WW_TWO_PI * 360.0)
    
void WWMath_RotatePoint(double inX, double inY, double radians, double* outX, double* outY);

    
    
#ifdef __cplusplus
}
#endif
#endif
