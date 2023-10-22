Shader "Antada/Rpg01/Particle/AddtiveUVanim"
{
    Properties
    {
        _TintColor ("Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}

        [Toggle(ENABLE_SCROLL)] _EnableScroll("Enable scroll", Float) = 0
        _ScrollXSpeed ("Scroll speed X", float) = 0
        _ScrollYSpeed ("Scroll speed Y", float) = 0
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
        Blend SrcAlpha One
        Cull Off Lighting Off ZWrite Off Fog { Mode Off }

        Pass
        {
            Name "Unlit"
            HLSLPROGRAM
            // Required to compile gles 2.0 with standard srp library
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            //#pragma target 2.0

            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature ENABLE_SCROLL

            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/UnlitInput.hlsl"

            TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex);

            struct Attributes
            {
                float4 positionOS       : POSITION;
                float2 uv               : TEXCOORD0;
                half4 color             : COLOR;
               
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct Varyings
            {
                float2 uv               : TEXCOORD0;
                float4 vertex           : SV_POSITION;
                half4 color             : COLOR;

                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };

            CBUFFER_START(UnityPerMaterial)
            float4 _MainTex_ST;
            float _ScrollXSpeed;
            float _ScrollYSpeed;
            half4 _TintColor;
            CBUFFER_END

            Varyings vert(Attributes input)
            {
                Varyings output = (Varyings)0;

                UNITY_SETUP_INSTANCE_ID(input);
                UNITY_TRANSFER_INSTANCE_ID(input, output);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

                output.color = input.color;

                float3 positionWS = TransformObjectToWorld(input.positionOS.xyz);
                output.vertex = TransformWorldToHClip(positionWS);
                output.uv = TRANSFORM_TEX(input.uv, _MainTex);
        
                #ifdef ENABLE_SCROLL
                    output.uv.x += _ScrollXSpeed * _Time.y;
                    output.uv.y += _ScrollYSpeed * _Time.y;
                #endif

                return output;
            }
  
            half4 frag(Varyings input) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(input);
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);
                half4 texColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, input.uv);
                texColor *= _TintColor;
                texColor *= input.color;
                return texColor;
            }

            ENDHLSL
        }        
    }
}
