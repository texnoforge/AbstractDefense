use gdnative::prelude::*;

#[derive(NativeClass)]
#[inherit(Node)]
pub struct Spawner;

impl Spawner {
    fn new(_owner: &Node) -> Self {
        Spawner
    }
}

#[methods]
impl Spawner {
    #[export]
    fn _ready(&self, _owner: &Node) {
        godot_print!("Spawner lock&loaded");
    }

    #[export]
    fn on_spawn_timer_timeout(&self, owner: &Node) {
        self.spawn();

        // Speed up timer
        let spawn_timer = unsafe { owner.get_node_as::<Timer>("spawn_timer").unwrap() };
        spawn_timer.set_wait_time(spawn_timer.wait_time() * 0.8);
    }
}

impl Spawner {
    fn spawn(&self) {
        godot_print!("spawn a Monster");
    }
}
