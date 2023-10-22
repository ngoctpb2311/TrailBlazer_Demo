#ifndef CHARACTER_CORE_H
#define CHARACTER_CORE_H

            #include "Packages/com.unity.render-pipelines.universal/Shaders/SimpleLitInput.hlsl"
            #include "BlendFunction.hlsl"

            TEXTURE2D(_RampTexture);            SAMPLER(sampler_RampTexture);
            TEXTURE2D(_SpecularTexture);        SAMPLER(sampler_SpecularTexture);

            float4 _RimColor;
            float _RimPower;

            struct Attributes
            {
                float4 positionOS    : POSITION;
                float3 normalOS      : NORMAL;
                float4 tangentOS     : TANGENT;
                float2 texcoord      : TEXCOORD0;                
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct Varyings
            {
                float2 uv                       : TEXCOORD0;
                //DECLARE_LIGHTMAP_OR_SH(lightmapUV, vertexSH, 1);
                float3 posWS                    : TEXCOORD2;    // xyz: posWS

                float4 extendVar                : TEXCOORD3; //x : NdotL (ramp), y = NdotH (specular), z = fogValue

                half3 rimColor                  : TEXCOORD4;

                float4 positionCS               : SV_POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };

            Varyings LitPassVertexSimple(Attributes input)
            {
                Varyings output = (Varyings)0;

                UNITY_SETUP_INSTANCE_ID(input);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

                VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
                VertexNormalInputs normalInput = GetVertexNormalInputs(input.normalOS, input.tangentOS);
                half3 normal = NormalizeNormalPerVertex(normalInput.normalWS);
                half3 viewDirWS = normalize(GetCameraPositionWS() - vertexInput.positionWS);

                output.uv = TRANSFORM_TEX(input.texcoord, _BaseMap);
                output.posWS.xyz = vertexInput.positionWS;
                output.positionCS = vertexInput.positionCS;
               
                output.extendVar.x = dot(normal, _MainLightPosition.xyz) * 0.5 + 0.5;

                //float3 halfVec = SafeNormalize(_MainLightPosition.xyz + viewDirWS);
                //float3 halfVec = SafeNormalize(viewDirWS);
                output.extendVar.y = saturate(dot(normal, viewDirWS));

                output.extendVar.z = ComputeFogFactor(vertexInput.positionCS.z);

                float diff = 1.0 - saturate(dot(normal, viewDirWS));
                diff = step(1.0 - _RimPower, diff) * diff;
                output.rimColor = step(1.0 - _RimPower, diff) * (diff - (1.0 - _RimPower)) / (1.0 - _RimPower) * _RimColor;

                return output;
            }

            half3 RampFeature(Varyings input, half3 baseTexture)
            {
                half3 ramp = SampleAlbedoAlpha(float2(input.extendVar.x, 0), TEXTURE2D_ARGS(_RampTexture, sampler_RampTexture)).rgb;
                return BlendOverlay(baseTexture, ramp);
            }

            half3 SpecularFeature(Varyings input, half3 baseTexture)
            {
                half3 specularSmoothness = SampleAlbedoAlpha(input.uv, TEXTURE2D_ARGS(_SpecularTexture, sampler_SpecularTexture)).rgb;

                // half smoothness = exp2(10 * [smoothValue] + 1);
                // half modifier = pow(input.extendVar.y, smoothness);
                half modifier = input.extendVar.y;

                specularSmoothness *= modifier;

                return baseTexture + specularSmoothness;
            }

            half3 RimFeature(Varyings input, half3 baseTexture)        
            {
                return baseTexture + input.rimColor;
            }

            half3 FogFeature(Varyings input, half3 baseTexture)
            {
                return MixFog(baseTexture.rgb, input.extendVar.z);
            }

#endif