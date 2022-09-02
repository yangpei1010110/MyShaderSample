Shader "Unlit/DepthTestDisplay"
{
    Properties
    {
        //        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma 3.0
            #pragma vertex vert
            #pragma fragment frag

            // make fog work
            // #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 clipPos : SV_POSITION;
                float4 scrPos : TEXCOORD0;
            };

            // sampler2D _MainTex;
            // float4 _MainTex_ST;

            uniform sampler2D _CameraDepthTexture;

            v2f vert(appdata_base v)
            {
                v2f o;
                o.clipPos = UnityObjectToClipPos(v.vertex);
                o.scrPos = ComputeScreenPos(o.clipPos);

                // COMPUTE_EYEDEPTH(o.scrPos.z);
                // o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                // UNITY_TRANSFER_FOG(o, o.vertex);
                return o;
            }

            fixed4 frag(v2f i) : COLOR
            {
                // // sample the texture
                // fixed4 col = tex2D(_MainTex, i.uv);
                // // apply fog
                // UNITY_APPLY_FOG(i.fogCoord, col);
                // return col;

                float4 proj = UNITY_PROJ_COORD(i.scrPos);
                float4 depthTexProj = SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, proj);
                //
                float sceneZ = 1.0 + (-1.0 * Linear01Depth(depthTexProj));
                // float sceneZ = depthTexProj;


                return float4(sceneZ, sceneZ, sceneZ, 1);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}