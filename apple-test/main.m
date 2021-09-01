#include <SDL2/SDL.h>
#import <Metal/Metal.h>
#import <QuartzCore/CAMetalLayer.h>

#include "player.h"

const char* defaultMoviePath = "apple-test/Intro.mp4";

void ToggleFullscreen(SDL_Window* window) {
    const bool fullscreen = SDL_GetWindowFlags(window) & SDL_WINDOW_FULLSCREEN_DESKTOP;
    SDL_SetWindowFullscreen(window, fullscreen ? 0 : SDL_WINDOW_FULLSCREEN_DESKTOP);
    SDL_ShowCursor(fullscreen);
}

int main(int argc, char **argv) {
    SDL_Init(SDL_INIT_VIDEO);
    SDL_Window* window = SDL_CreateWindow(
        "Test Case",
        SDL_WINDOWPOS_CENTERED,
        SDL_WINDOWPOS_CENTERED,
        640,
        480,
        SDL_WINDOW_METAL | SDL_WINDOW_RESIZABLE | SDL_WINDOW_ALLOW_HIGHDPI
    );

    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    SDL_MetalView view = SDL_Metal_CreateView(window);
    CAMetalLayer *layer = (__bridge CAMetalLayer *)(SDL_Metal_GetLayer(view));
    layer.device = device;
    layer.pixelFormat = MTLPixelFormatBGRA8Unorm;

    id<MTLCommandQueue> commandQueue = [device newCommandQueue];
    
    MyPlayer* player = [[MyPlayer alloc] init:(__bridge NSView *)(view)];
    
    SDL_Event e;
    int quit = 0;
    while (!quit) {
        while (SDL_PollEvent(&e)) {
            if (e.type == SDL_QUIT) {
                quit = 1;
            }
            else if(e.type == SDL_WINDOWEVENT)
            {
                switch(e.window.event)
                {
                    case(SDL_WINDOWEVENT_SIZE_CHANGED):
                    {
                        [player resize: NSMakeRect(0.f, 0.f, e.window.data1, e.window.data2)];
                    }
                    default:
                        break;
                }
            }
            else if(e.type == SDL_KEYDOWN)
            {
                switch(e.key.keysym.sym)
                {
                    case SDLK_p:
                    {
                        [player play:defaultMoviePath];
                        break;
                    }
                    case SDLK_f:
                    {
                        ToggleFullscreen(window);
                        break;
                    }
                    case SDLK_q:
                    {
                        quit = 1;
                        break;
                    }
                    default:
                        break;
                }
            }
        }

        id<CAMetalDrawable> drawable = [layer nextDrawable];
        MTLRenderPassDescriptor *passDesc = [MTLRenderPassDescriptor renderPassDescriptor];
        passDesc.colorAttachments[0].texture = drawable.texture;
        passDesc.colorAttachments[0].loadAction = MTLLoadActionClear;
        passDesc.colorAttachments[0].storeAction = MTLStoreActionStore;
        passDesc.colorAttachments[0].clearColor = MTLClearColorMake(1.0, 0.0, 1.0, 1.0);
        id<MTLCommandBuffer> commandBuffer = [commandQueue commandBuffer];
        id<MTLRenderCommandEncoder> encoder = [commandBuffer renderCommandEncoderWithDescriptor:passDesc];
        [encoder endEncoding];
        [commandBuffer presentDrawable:drawable];
        [commandBuffer commit];

        SDL_Delay(16);
    }
    SDL_Metal_DestroyView(view);
    SDL_DestroyWindow(window);
    SDL_Quit();
}
