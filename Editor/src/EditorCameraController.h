//
// Created by Andrew Graser on 2/4/2026.
//


#pragma once

#include "Tungsten/Core/Camera.h"

namespace Tungsten {
    class EditorCameraController {
    public:
        EditorCameraController() : EditorCameraController(glm::vec3(0.0)) {}
        EditorCameraController(const glm::vec3& pos);

        ~EditorCameraController() = default;


    public:
        inline std::shared_ptr<Camera>& GetCamera() {return mCamera;}
        inline const glm::vec3& GetPosition() const {return mCamera->GetPosition();}

        void OnUpdate();



    private:
        std::shared_ptr<Camera> mCamera;


        float mMoveSpeed = 10.f;
        float mSensitivity = 10.f;

        float mPrevX, mPrevY;
    };
}
