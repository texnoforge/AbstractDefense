use gdnative::prelude::*;

mod test_scene;

// Function that registers all exposed classes to Godot
fn init(handle: InitHandle) {
    handle.add_class::<test_scene::TestScene>();
}

// Macro that creates the entry-points of the dynamic library.
godot_init!(init);
