package raymath_angle_example

import rl "vendor:raylib"
import "core:math"
import "core:math/linalg"

main :: proc() {

    screenWidth : i32 = 800
    screenHeight : i32 = 450

    rl.InitWindow(screenWidth, screenHeight, "raylib [math] example - vector angle")

    v0 : rl.Vector2 = {f32(screenWidth/2), f32(screenHeight / 2)}
    v1 : rl.Vector2 = rl.Vector2Add(v0, {100, 80})
    v2 : rl.Vector2 = {0, 0}

    odinAngle : f32 = 0.0
    raylibAngle: f32 = 0.0
    angleMode : bool = false

    rl.SetTargetFPS(60)

    for !rl.WindowShouldClose() {
        startAngle : f32 = 0.0
        if !angleMode do startAngle = -rl.Vector2LineAngle(v0, v1)*rl.RAD2DEG
        if angleMode do startAngle = 0

        v2 = rl.GetMousePosition()

        if rl.IsKeyPressed(rl.KeyboardKey.SPACE) do angleMode = !angleMode

        if !angleMode && rl.IsMouseButtonDown(rl.MouseButton.RIGHT) do v1 = rl.GetMousePosition()

        if !angleMode {
            v1Normal := rl.Vector2Normalize(v1 - v0)
            v2Normal := rl.Vector2Normalize(v2 - v0)

            odinAngle = rl.Vector2Angle(v1Normal, v2Normal)*rl.RAD2DEG
            // native raylib implementation of Vector2Angle
            dot:= v1Normal.x*v2Normal.x + v1Normal.y*v2Normal.y
            det:= v1Normal.x*v2Normal.y - v1Normal.y*v2Normal.x
            raylibAngle = math.atan2(det, dot)*rl.RAD2DEG

        } else {
            odinAngle = rl.Vector2LineAngle(v0, v2)*rl .RAD2DEG
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.RAYWHITE)

        if !angleMode {
            rl.DrawText("MODE 0: Angle between V1 and V2", 10, 10, 20, rl.BLACK);
            rl.DrawText("Right Click to Move V2", 10, 30, 20, rl.DARKGRAY);

            rl.DrawLineEx(v0, v1, 2.0, rl.BLACK)
            rl.DrawLineEx(v0, v2, 2.0, rl.RED)
            rl.DrawCircleSector(v0, 40, startAngle, startAngle + odinAngle, 32, rl.Fade(rl.GREEN, 0.6))
            rl.DrawCircleSector(v0, 40, startAngle, startAngle + raylibAngle, 32, rl.Fade(rl.BLUE, 0.6))

        } else {
            rl.DrawText("MODE 1: Angle formed by line V1 to V2", 10, 10, 20, rl.BLACK);

            rl.DrawLine(0, screenHeight/2, screenWidth, screenHeight/2, rl.LIGHTGRAY);
            rl.DrawLineEx(v0, v2, 2.0, rl.RED);

            rl.DrawCircleSector(v0, 40.0, startAngle, startAngle - odinAngle, 32, rl.Fade(rl.GREEN, 0.6));
        }

        rl.DrawText("v0", i32(v0.x), i32(v0.y), 10, rl.DARKGRAY)

        if !angleMode && rl.Vector2Subtract(v0, v1).y > 0 {
            rl.DrawText("v1", cast(i32) v1.x, cast(i32) v1.y-10.0, 10, rl.DARKGRAY);
        }
        if !angleMode && rl.Vector2Subtract(v0, v1).y < 0 {
            rl.DrawText("v1", cast(i32) v1.x, cast(i32) v1.y, 10, rl.DARKGRAY);
        }

        if angleMode do rl.DrawText("v1", cast(i32) v0.x + 40, cast(i32) v0.y, 10, rl.DARKGRAY)

        // position adjusted by -10 so it isn't hidden by cursor
        rl.DrawText("v2", cast(i32) v2.x-10.0, cast(i32) v2.y-10.0, 10, rl.DARKGRAY);

        rl.DrawText("Press SPACE to change MODE", 460, 10, 20, rl.DARKGRAY);
        rl.DrawText(rl.TextFormat("ODIN ANGLE: %2.2f", odinAngle), 10, 70, 20, rl.LIME);
        rl.DrawText(rl.TextFormat("RAYLIB ANGLE: %2.2f", raylibAngle), 10, 100, 20, rl.LIME);

        rl.EndDrawing()
    }

    rl.CloseWindow()

}
