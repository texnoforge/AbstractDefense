use gdnative::prelude::*;

#[derive(NativeClass)]
#[inherit(Node)]
pub struct TestScene;

impl TestScene {
    fn new(_owner: &Node) -> Self {
        TestScene
    }
}

#[methods]
impl TestScene {
    #[export]
    fn _ready(&self, _owner: &Node) {
        godot_print!("Hello from Rust!");
    }
}
