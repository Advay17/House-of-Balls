shader_type canvas_item;
uniform int state: hint_enum("Normal", "Parrying");

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if(state == 1) { //Parrying
		COLOR.r = 1.0;
		COLOR.g = 1.0;
		COLOR.b = 1.0;
	}
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
