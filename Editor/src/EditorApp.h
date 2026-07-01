//
// Created by Andrew Graser on 12/5/2025.
//


#pragma once

#include "Tungsten.h"
#include "EditorCameraController.h"

namespace Tungsten {
    class EditorApp {
    public:
        EditorApp();

    public:
        void OnStart();
        void OnUpdate();
        void OnImGuiRender();



    private:
        std::unique_ptr<EditorCameraController> mCameraController;
    };
}
