//
//  ObjectManager.h
//  Snap2Life
//
//  Created by prisma on 14.10.12.
//  Copyright (c) 2012 Prisma Gmbh. All rights reserved.
//
//  The ObjectManager manages the three objects: dataSet, objects3D and textures involved in AR.
//  It is initialized with an empty dataSet and with references to the (empty) objects3D and textures
//  arrays in the EAGLView and AR_EAGLView respectively.
//
//  Most importantly, the ObjectManager implements the QCAR::QCAR_onUpdate callback which is called before
//  the execution of each run of the QCAR loop.
//
//  When new models become available by dynamic AR loading, they are retained in the manager and
//  their contents are swapped to the current dataSet, objects3D and textures when the callback
//  is executed.
//
//  The boolean renderingInited, if non-NULL at instantiation, is set to false when the swap is
//  successful. This switch forces the EAGLView to re-initialize OpenGL with the new textures.
//
//  The C++ class makes use of Toll Free Bridging to modify the NSMutableArrays of the objects3D
//  and textures, making them available with new content for the next pass through the Qualcomm loop.

#ifndef __Snap2Life__ObjectManager__
#define __Snap2Life__ObjectManager__

#include "UpdateCallback.h"
#include "DataSet.h"


@class Texture;


namespace AR {
    
    class ObjectManager : public QCAR::UpdateCallback, private QCAR::NonCopyable {
    public:
        // Initializes with an empty dataSet and with references to the (empty) objects3D and textures
        // arrays in the EAGLView and AR_EAGLView respectively.
        ObjectManager(CFMutableArrayRef objects3D, CFMutableArrayRef textures, bool* renderingInited);
        
        virtual ~ObjectManager();
        
        // Called by the SDK right after tracking finishes.
        virtual void QCAR_onUpdate(QCAR::State& state);
        
        // Sets the new data set, model, textures and reload callback before switchDataSetAsap is changed.
        void setNewData(QCAR::DataSet* dataSet, CFMutableArrayRef objects3D, CFMutableArrayRef textures);
        
        // Boolean switch to tell Qualcomm to call the body of the callback in the main Qualcomm loop.
        bool switchDataSetAsap;
        
    private:
        // Sets the new dataSet by value.
        void setDataSet(QCAR::DataSet* dataSet);
        
        // Retains the new objects3D.
        void setObjects(CFMutableArrayRef objects3D);
        
        // Retains the new textures.
        void setTextures(CFMutableArrayRef textures);
        
        QCAR::DataSet* dataSet_;
        QCAR::DataSet* dataSetNew_;
        CFMutableArrayRef objects3D_;  // Arrays of current and new Object3D
        CFMutableArrayRef objects3DNew_;
        CFMutableArrayRef textures_;   // Arrays of current and new textures
        CFMutableArrayRef texturesNew_;
        bool* renderingInited_;
    };
}

#endif /* defined(__Snap2Life__ObjectManager__) */
