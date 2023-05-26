shader_type canvas_item;

uniform float fade_duration;
uniform float fade_delay;
uniform bool disable_fade=true;

void fragment() {
	
	float time = TIME;
    float alpha = 1.0;
	

    if (time > fade_delay && disable_fade ==false) {
        alpha = clamp(1.0 - ((time - fade_delay) / fade_duration), 0.0, 1.0);
    }
	if (disable_fade==true){
		alpha = 1.0;
	}
    COLOR.a *= alpha;
}
