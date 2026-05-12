#include "imgui/imgui.h"
#include "imgui_backends/imgui_impl_glfw.h"
#include "imgui_backends/imgui_impl_metal.h"
#include <GLFW/glfw3.h>
#include <stdio.h>

#define GLFW_EXPOSE_NATIVE_COCOA
#include <GLFW/glfw3native.h>

#import <Metal/Metal.h>
#import <QuartzCore/QuartzCore.h>

int main() {
  if (!glfwInit())
    return 1;

  glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);

  GLFWwindow *window = glfwCreateWindow(800, 600, "gooey", NULL, NULL);
  if (window == nullptr)
    return 1;

  id<MTLDevice> device = MTLCreateSystemDefaultDevice();
  id<MTLCommandQueue> commandQueue = [device newCommandQueue];

  NSWindow *nswin = glfwGetCocoaWindow(window);
  CAMetalLayer *layer = [CAMetalLayer layer];
  layer.device = device;
  layer.pixelFormat = MTLPixelFormatBGRA8Unorm;
  nswin.contentView.layer = layer;
  nswin.contentView.wantsLayer = YES;

  IMGUI_CHECKVERSION();
  ImGui::CreateContext();
  ImGuiIO &io = ImGui::GetIO();
  io.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard;

  ImGui_ImplGlfw_InitForOther(window, true);
  ImGui_ImplMetal_Init(device);

  MTLRenderPassDescriptor *renderPassDescriptor =
      [MTLRenderPassDescriptor renderPassDescriptor];

  while (!glfwWindowShouldClose(window)) {
    glfwPollEvents();

    ImGui_ImplMetal_NewFrame(renderPassDescriptor);
    ImGui_ImplGlfw_NewFrame();
    ImGui::NewFrame();

    ImGui::Begin("begin");
    ImGui::BeginTabBar("tabbar");
    ImGui::BeginTabItem("tabitem");
    if (ImGui::Button("close"))
      glfwSetWindowShouldClose(window, GL_TRUE);
    ImGui::EndTabItem();
    ImGui::EndTabBar();
    ImGui::End();

    ImGui::Render();

    id<CAMetalDrawable> drawable = [layer nextDrawable];
    if (drawable) {
      renderPassDescriptor.colorAttachments[0].texture = drawable.texture;
      renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
      renderPassDescriptor.colorAttachments[0].storeAction =
          MTLStoreActionStore;
      renderPassDescriptor.colorAttachments[0].clearColor =
          MTLClearColorMake(.45f, .55f, .60f, 1.f);

      id<MTLCommandBuffer> commandBuffer = [commandQueue commandBuffer];
      id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer
          renderCommandEncoderWithDescriptor:renderPassDescriptor];

      [renderEncoder pushDebugGroup:@"ImGui_Render"];
      ImGui_ImplMetal_RenderDrawData(ImGui::GetDrawData(), commandBuffer,
                                     renderEncoder);
      [renderEncoder popDebugGroup];

      [renderEncoder endEncoding];
      [commandBuffer presentDrawable:drawable];
      [commandBuffer commit];
    };
  };

  ImGui_ImplMetal_Shutdown();
  ImGui_ImplGlfw_Shutdown();
  ImGui::DestroyContext();
  glfwDestroyWindow(window);
  glfwTerminate();

  return 0;
}
