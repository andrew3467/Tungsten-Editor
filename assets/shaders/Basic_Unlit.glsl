#type vertex
#version 460


layout (location = 0) in vec3 aPosition;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec2 aTexCoord;


out VS_OUT{
    vec3 FragPos;
    vec3 Normal;
    vec2 TexCoord;
} vs_out;

uniform mat4 uViewProj;
uniform mat4 uModel;

void main() {
    vs_out.TexCoord = aTexCoord;

    gl_Position = uViewProj * uModel * vec4(aPosition, 1.0);
    vs_out.FragPos = vec3(uModel * vec4(aPosition, 1));
}



#type fragment
#version 460

layout (location = 0) out vec4 FragColor;


in VS_OUT{
    vec3 FragPos;
    vec3 Normal;
    vec2 TexCoord;
} fs_in;


layout (binding = 0) uniform sampler2D uAlbedoMap;       //Slot 0


uniform vec3 uColor;

void main() {
    vec4 texColor = texture(uAlbedoMap, fs_in.TexCoord);

    if(texColor.a != 1) discard;

    FragColor = texColor * vec4(uColor, 1);
}