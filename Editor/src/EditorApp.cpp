//
// Created by Andrew Graser on 12/5/2025.
//

#include "EditorApp.h"


#include <imgui.h>

namespace Tungsten {

    void EditorApp::OnStart() {
        TUNGSTEN_INFO("Initializing Editor");

        mCameraController = std::make_unique<EditorCameraController>();
        DefaultCamera = mCameraController->GetCamera();
    }

    void EditorApp::OnUpdate() {
        mCameraController->OnUpdate();

        Renderer::DrawCube(glm::vec3(0, 0, 6), glm::vec3(1), glm::vec3(glm::vec3(1,0,1)));
    }

    void EditorApp::OnImGuiRender() {
        ImGui::Begin("Test"); ImGui::End();
    }

    EditorApp::EditorApp() {
        Engine engine("Tungsten Editor");
        engine.Run([this]() {OnUpdate();}, [this]() {OnStart();}, [this]() {OnImGuiRender();});
    }
}