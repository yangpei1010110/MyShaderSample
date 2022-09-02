Shader "Unlit/DitherPattern"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Value ("Value", Range(0,1.0)) = 0.5
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 200

        Pass
        {
            CGPROGRAM
            #pragma target 3.5
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            // #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "UnityShaderVariables.cginc"

            float _Value;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                // UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float4 screenPos : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.screenPos = ComputeScreenPos(o.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float4x4 m = float4x4(
                    0.0 / 16.0, 8.0 / 16.0, 2.0 / 16.0, 10.0 / 16.0,
                    12.0 / 16.0, 4.0 / 16.0, 14.0 / 16.0, 6.0 / 16.0,
                    3.0 / 16.0, 11.0 / 16.0, 1.0 / 16.0, 9.0 / 16.0,
                    15.0 / 16.0, 7.0 / 16.0, 13.0 / 16.0, 5.0 / 16.0
                );

                float4 screenPos = i.screenPos;
                screenPos.xy = ((screenPos.xy / screenPos.w) * 0.5 + 0.5) * _ScreenParams.xy;
                // screenPos.xy /= screenPos.w;
                // screenPos.xy *= 0.5;
                // screenPos.xy += 0.5;
                // screenPos.xy *= _ScreenParams.xy;
                float x = (fmod((screenPos.x), 4.0));
                float y = (fmod((screenPos.y), 4.0));
                clip(m[y][x] - _Value);

                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}