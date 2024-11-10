shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx;




global uniform float tauxalcool;
instance uniform float seed = 0;
instance uniform float Alpha = 1;
instance uniform float Scale = 1;
uniform vec4 albedo_color_surface;




void vertex() {
// Input:3
	float n_out3p0 = TIME;


// FloatFunc:4
	float n_out4p0 = abs(n_out3p0);


// Input:2
	vec3 n_out2p0 = VERTEX;
	float n_out2p1 = n_out2p0.r;
	float n_out2p2 = n_out2p0.g;
	float n_out2p3 = n_out2p0.b;


// FloatOp:14
	float n_out14p0 = n_out4p0 + n_out2p2;

// FloatFunc:12
	float n_out12p0 = sin(n_out14p0);

// FloatFunc:28
	float n_out28p0 = cos(n_out14p0);


// FloatOp:16
	float n_out16p0 = n_out12p0 * n_out28p0;


// FloatConstant:30
//	float n_out30p0 = tauxalcool;
	  float n_out30p0 = 1.00000;

// FloatOp:29
	float n_in29p1 = 0.50000/Scale;
	float n_out29p0 = n_out30p0 * n_in29p1;


// FloatOp:15
	float n_out15p0 = n_out16p0 * n_out29p0;


// FloatOp:13
	float n_out13p0 = n_out15p0 + n_out2p1;


// FloatOp:24
	float n_in24p1 = 0.50000/Scale;
	float n_out24p0 = n_out30p0 * n_in24p1;


// Input:19
	float n_out19p0 = TIME;


// FloatParameter:20
	float n_out20p0 = seed;


// FloatConstant:27
	float n_out27p0 = 6.283000;


// FloatOp:25
	float n_out25p0 = n_out20p0 * n_out27p0;


// FloatOp:23
	float n_out23p0 = n_out19p0 + n_out25p0;


// FloatFunc:18
	float n_out18p0 = sin(n_out23p0);


// FloatOp:22
	float n_out22p0 = n_out24p0 * n_out18p0;


// FloatOp:17
	float n_out17p0 = n_out13p0 + n_out22p0;


// VectorCompose:6
	vec3 n_out6p0 = vec3(n_out17p0, n_out2p2, n_out2p3);


// Output:0
	VERTEX = n_out6p0;
}

void fragment() {
// FloatParameter:3
	float n_out3p0 = Alpha;
	

// Output:0
	ALPHA = n_out3p0;
	ALBEDO = albedo_color_surface.rgb;

}
