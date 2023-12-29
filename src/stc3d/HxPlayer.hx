package stc3d;

import godot.variant.*;

class HxPlayer extends godot.CharacterBody3D {
  @:export
  public var speed(default, default): Int = 14;

  @:export
  public var fallAcceleration(default, default): Int = 75;

  private var targetVelocity: Vector3 = new Vector3();
  private var pivot: godot.Node3D;

  public override function _ready() {
    this.pivot = this.get_node("Pivot").as(godot.Node3D);
  }

  public override function _physics_process(delta: Float) {
    if (godot.Engine.singleton().is_editor_hint()) return;

    var direction = new Vector3();
    var input = godot.Input.singleton();

    if (input.is_action_pressed(Movement.MoveLeft, false)) {
      direction.x -= 1;
    }
    if (input.is_action_pressed(Movement.MoveRight, false)) {
      direction.x += 1;
    }
    if (input.is_action_pressed(Movement.MoveForward, false)) {
      direction.z -= 1;
    }
    if (input.is_action_pressed(Movement.MoveBack, false)) {
      direction.z += 1;
    }

    if (direction != new Vector3()) {
      direction = direction.normalized();
      this.pivot.look_at(this.position + direction, Vector3.UP());
    }

    this.targetVelocity.x = direction.x * this.speed;
    this.targetVelocity.z = direction.z * this.speed;

    if (!this.is_on_floor()) {
      this.targetVelocity.y -= this.fallAcceleration * delta;
    }

    this.velocity = this.targetVelocity;
    this.move_and_slide();
  }
}
