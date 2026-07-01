#type vertex
#version 460


layout (location = 0) in vec3 aPosition;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec2 aTexCoord;


out VS_OUT{
    vec3 FragPos;
    vec3 Normal;
    vec2 TexCoord;

    float Height;
} vs_out;

uniform mat4 uViewProj;
uniform mat4 uModel;

void main() {
    vec3 flatPos = vec3(aPosition.x, 0, aPosition.z);

    vs_out.Height = aPosition.y;

    vs_out.TexCoord = aTexCoord;
    vs_out.Normal = mat3(transpose(inverse(uModel))) * aNormal;

    if(false) {
        gl_Position = uViewProj * uModel * vec4(aPosition, 1.0);
        vs_out.FragPos = vec3(uModel * vec4(aPosition, 1));
    }
    else {
        gl_Position = uViewProj * uModel * vec4(flatPos, 1.0);
        vs_out.FragPos = vec3(uModel * vec4(flatPos, 1));
    }
}



#type fragment
#version 460

layout (location = 0) out vec4 FragColor;


in VS_OUT{
    vec3 FragPos;
    vec3 Normal;
    vec2 TexCoord;

    float Height;
} fs_in;

struct DirLight {
    vec3 dir;
    vec3 color;
};

struct PointLight {
    vec3 Position;
    vec3 Color;

    float Constant;
    float Linear;
    float Quadratic;
};
const int MAX_POINT_LIGHTS = 32;


layout (binding = 0) uniform sampler2D uAlbedoMap;       //Slot 0


uniform vec3 uColor;
uniform vec3 uViewPos;

uniform DirLight uDirLight;

uniform int uNumLights;
uniform PointLight uPointLights[MAX_POINT_LIGHTS];

vec3 calcPointLight(PointLight light, vec3 normal, vec3 viewDir) {
    vec3 N = normalize(normal);
    vec3 L = normalize(light.Position - fs_in.FragPos);
    vec3 V = normalize(viewDir);
    vec3 H = normalize(L + V);

    //Ambient
    vec3 ambient = light.Color * 0.1;

    //Diffuse
    float diff = max(dot(N, L), 0.0);
    vec3 diffuse = 0.1 * light.Color * diff;

    //Specular
    float shininess = 1;
    float spec = 0.0f;
    if(diff > 0.0) {
        spec = pow(max(dot(N, H), 0.0), shininess);
    }
    vec3 specular = 0.1 * light.Color * spec;

    //Attenuation
    float distance = length(light.Position - fs_in.FragPos);
    float attenuation = 1.0 / (
    light.Constant +
    light.Linear * distance +
    light.Quadratic * (distance * distance)
    );

    return  attenuation * (diffuse + specular);
}

vec3 calcDirLight(DirLight light, vec3 normal, vec3 viewDir) {
    vec3 N = normalize(normal);
    vec3 L = normalize(-light.dir);
    vec3 V = normalize(viewDir);
    vec3 H = normalize(L + V);

    //Diffuse
    float diff = max(dot(N, L), 0.0);
    vec3 diffuse = 1.0 * light.color * diff;

    //Specular
    float shininess = 32;
    float spec = 0.0f;
    if(diff > 0.0) {
        spec = pow(max(dot(N, H), 0.0), shininess);
    }
    vec3 specular = 0.1 * light.color * spec;

    return diffuse + specular;
}

void main() {
    vec3 normal = normalize(fs_in.Normal);
    vec3 viewDir = normalize(uViewPos - fs_in.FragPos);


    vec4 texColor = texture(uAlbedoMap, fs_in.TexCoord);
    if(texColor.a != 1) discard;

    vec3 outColor = uColor * texColor.rgb;

    vec3 light = calcDirLight(uDirLight, normal, viewDir);

    for(int i = 0; i < uNumLights; i++){
        light += calcPointLight(uPointLights[i], normal, fs_in.FragPos);
    }



    outColor *= light;

    //gamma correction
    outColor = pow(outColor, vec3(1.0/2.2));

    vec3 c = vec3(fs_in.Height);
    FragColor = vec4(c, 1);
}