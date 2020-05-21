// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tsuna/Fake Iridescence Cutout FX"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[SingleLineTexture]_MainTex("Albedo Map", 2D) = "white" {}
		_Color("Albedo Color", Color) = (1,1,1,0)
		[SingleLineTexture]_MetallicGlossMap("Metallic Map", 2D) = "white" {}
		_Metaliic("Metallic Slider", Range( 0 , 1)) = 0
		_Glossiness("Smoothness Slider", Range( 0 , 1)) = 0
		[Toggle(_)]_UseNormalMap("Use Normal Map", Float) = 0
		[Normal][SingleLineTexture]_BumpMap("Normal Map", 2D) = "bump" {}
		_NormalMapSlider("Normal Map Slider", Range( 0 , 5)) = 1
		_EmissionColor("Emission Color", Color) = (0,0,0,0)
		[SingleLineTexture]_EmissionMap("Emission Map", 2D) = "white" {}
		_TilingandOffset("Tiling and Offset", Vector) = (1,1,0,0)
		[Header(Fresnel)]_Bias("Bias", Range( 0 , 10)) = 1
		_Power("Power", Range( 0 , 10)) = 1
		_Scale("Scale", Range( 0 , 10)) = 1
		_Strength("Strength", Range( 0 , 10)) = 1
		[Toggle(_)][Header(Chroma)]_ToggleChroma("Toggle Chroma", Float) = 0
		_Speed("Speed", Range( 0 , 2)) = 1
		[Header(Cull)]_BackfaceDimming("Backface Dimming", Range( 0 , 1)) = 0
		_Cull1("Cull Mode ( 0 = None, 1 = Front, 2 = Back)", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull [_Cull1]
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			half ASEVFace : VFACE;
		};

		uniform float _Cull1;
		uniform float _UseNormalMap;
		uniform float _NormalMapSlider;
		uniform sampler2D _BumpMap;
		uniform float4 _TilingandOffset;
		uniform float4 _Color;
		uniform sampler2D _MainTex;
		uniform float _ToggleChroma;
		uniform float _Bias;
		uniform float _Scale;
		uniform float _Power;
		uniform float _Speed;
		uniform float _Strength;
		uniform float _BackfaceDimming;
		uniform sampler2D _EmissionMap;
		uniform float4 _EmissionColor;
		uniform float _Metaliic;
		uniform sampler2D _MetallicGlossMap;
		uniform float _Glossiness;
		uniform float _Cutoff = 0.5;


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 _Vector1 = float3(0,0,1);
			float2 appendResult36 = (float2(_TilingandOffset.x , _TilingandOffset.y));
			float2 appendResult35 = (float2(_TilingandOffset.z , _TilingandOffset.w));
			float2 uv_TexCoord37 = i.uv_texcoord * appendResult36 + appendResult35;
			float3 ifLocalVar49 = 0;
			if( _UseNormalMap == 1.0 )
				ifLocalVar49 = UnpackScaleNormal( tex2D( _BumpMap, uv_TexCoord37 ), _NormalMapSlider );
			else
				ifLocalVar49 = _Vector1;
			o.Normal = ifLocalVar49;
			float4 tex2DNode5 = tex2D( _MainTex, uv_TexCoord37 );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float fresnelNdotV8 = dot( (WorldNormalVector( i , ifLocalVar49 )), ase_worldViewDir );
			float fresnelNode8 = ( _Bias + _Scale * pow( 1.0 - fresnelNdotV8, _Power ) );
			float mulTime17 = _Time.y * _Speed;
			float ifLocalVar61 = 0;
			if( _ToggleChroma == 1.0 )
				ifLocalVar61 = ( mulTime17 + fresnelNode8 );
			else
				ifLocalVar61 = fresnelNode8;
			float3 hsvTorgb3_g2 = HSVToRGB( float3(ifLocalVar61,1.0,1.0) );
			float3 temp_output_6_6 = hsvTorgb3_g2;
			float4 lerpResult25 = lerp( ( _Color * tex2DNode5 ) , float4( temp_output_6_6 , 0.0 ) , _Strength);
			o.Albedo = ( lerpResult25 * (_BackfaceDimming + (i.ASEVFace - -1.0) * (1.0 - _BackfaceDimming) / (1.0 - -1.0)) ).rgb;
			o.Emission = ( ( tex2D( _EmissionMap, uv_TexCoord37 ) * _EmissionColor ) + float4( temp_output_6_6 , 0.0 ) ).rgb;
			float4 tex2DNode47 = tex2D( _MetallicGlossMap, uv_TexCoord37 );
			o.Metallic = ( _Metaliic * tex2DNode47 ).r;
			o.Smoothness = ( _Glossiness * tex2DNode47.a );
			o.Alpha = 1;
			clip( tex2DNode5.a - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17900
227.2;241.6;1974;1251;1837.443;581.3899;1.678715;True;False
Node;AmplifyShaderEditor.Vector4Node;34;-936.308,909.8344;Inherit;False;Property;_TilingandOffset;Tiling and Offset;11;0;Create;False;0;0;False;0;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;36;-664.308,861.8344;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;35;-664.308,1021.834;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;37;-488.3079,909.8344;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;40;-292.8257,1134.305;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;56;-2402.724,653.5223;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-2669.733,878.052;Inherit;False;Property;_NormalMapSlider;Normal Map Slider;8;0;Create;False;0;0;False;0;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;43;-2221.733,1054.052;Inherit;False;Constant;_Vector1;Vector 0;11;0;Create;True;0;0;False;0;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;44;-2365.733,846.052;Inherit;True;Property;_BumpMap;Normal Map;7;2;[Normal];[SingleLineTexture];Create;False;0;0;False;0;-1;None;76767365615d599459ecab5afc9a0bdb;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;46;-2253.732,750.0521;Inherit;False;Property;_UseNormalMap;Use Normal Map;6;0;Create;False;0;0;False;1;Toggle(_);0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;49;-1984.748,873.2618;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-2034.178,-61.25079;Inherit;False;Property;_Speed;Speed;17;0;Create;True;0;0;False;0;1;0.593;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1693.163,392.6377;Inherit;False;Property;_Bias;Bias;12;0;Create;True;0;0;False;1;Header(Fresnel);1;1.76;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;9;-1666,209;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;22;-1678.163,481.6377;Inherit;False;Property;_Scale;Scale;14;0;Create;True;0;0;False;0;1;1.74;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1685.163,577.6377;Inherit;False;Property;_Power;Power;13;0;Create;True;0;0;False;0;1;1.05;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;8;-1430.02,188.3112;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;17;-1648.778,28.94923;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;59;-272.802,816.5166;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-1439.777,-233.2876;Inherit;False;Property;_ToggleChroma;Toggle Chroma;16;0;Create;True;0;0;False;2;Toggle(_);Header(Chroma);0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;60;-1316.43,13.87561;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;58;-1007.511,712.678;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;64;-187.0846,800.7725;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;13;-798.5253,-386.5656;Inherit;False;Property;_Color;Albedo Color;2;0;Create;False;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ConditionalIfNode;61;-1124.356,-43.09525;Inherit;True;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-859,-213;Inherit;True;Property;_MainTex;Albedo Map;1;1;[SingleLineTexture];Create;False;0;0;False;0;-1;None;0ad9b3b9e20ca094793ed614245a009f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;63;-901.277,735.225;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-541.2458,-410.4247;Inherit;False;Property;_BackfaceDimming;Backface Dimming;18;0;Create;False;0;0;False;1;Header(Cull);0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;26;-756.5844,357.6264;Inherit;True;Property;_EmissionMap;Emission Map;10;1;[SingleLineTexture];Create;True;0;0;False;0;-1;None;db0e0545abb52ea45b2375c99c78af9b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;6;-837.2429,2.711478;Inherit;True;Simple HUE;-1;;2;32abb5f0db087604486c2db83a2e817a;0;1;1;FLOAT;0;False;4;FLOAT3;6;FLOAT;7;FLOAT;5;FLOAT;8
Node;AmplifyShaderEditor.FaceVariableNode;32;-371.8099,-520.4742;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;27;-734.3011,625.0271;Inherit;False;Property;_EmissionColor;Emission Color;9;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1;-482.1964,-195.4325;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-525.1119,116.6382;Inherit;False;Property;_Strength;Strength;15;0;Create;True;0;0;False;0;1;10;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;31;-193.4606,-471.6584;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;39.69219,941.8344;Inherit;False;Property;_Glossiness;Smoothness Slider;5;0;Create;False;0;0;False;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;25;-115.5658,-14.90773;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-322.0583,550.378;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;45;39.69219,653.8345;Inherit;False;Property;_Metaliic;Metallic Slider;4;0;Create;False;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;47;23.69219,749.8344;Inherit;True;Property;_MetallicGlossMap;Metallic Map;3;1;[SingleLineTexture];Create;False;0;0;False;0;-1;None;b40f8bcce7451254c8e18eed6df03b76;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;57;-553.2673,220.5773;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;239.8127,-158.7263;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;423.692,685.8345;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;423.692,845.8344;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-86.72955,238.5089;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;29;428.4483,-189.7586;Inherit;False;Property;_Cull1;Cull Mode ( 0 = None, 1 = Front, 2 = Back);19;0;Create;False;0;0;True;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;749.3458,100.859;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Tsuna/Fake Iridescence Cutout FX;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;True;29;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;36;0;34;1
WireConnection;36;1;34;2
WireConnection;35;0;34;3
WireConnection;35;1;34;4
WireConnection;37;0;36;0
WireConnection;37;1;35;0
WireConnection;40;0;37;0
WireConnection;56;0;40;0
WireConnection;44;1;56;0
WireConnection;44;5;41;0
WireConnection;49;0;46;0
WireConnection;49;2;43;0
WireConnection;49;3;44;0
WireConnection;49;4;43;0
WireConnection;9;0;49;0
WireConnection;8;0;9;0
WireConnection;8;1;20;0
WireConnection;8;2;22;0
WireConnection;8;3;21;0
WireConnection;17;0;15;0
WireConnection;59;0;37;0
WireConnection;60;0;17;0
WireConnection;60;1;8;0
WireConnection;58;0;59;0
WireConnection;64;0;37;0
WireConnection;61;0;62;0
WireConnection;61;2;8;0
WireConnection;61;3;60;0
WireConnection;61;4;8;0
WireConnection;5;1;58;0
WireConnection;63;0;64;0
WireConnection;26;1;63;0
WireConnection;6;1;61;0
WireConnection;1;0;13;0
WireConnection;1;1;5;0
WireConnection;31;0;32;0
WireConnection;31;3;30;0
WireConnection;25;0;1;0
WireConnection;25;1;6;6
WireConnection;25;2;11;0
WireConnection;28;0;26;0
WireConnection;28;1;27;0
WireConnection;47;1;37;0
WireConnection;57;0;6;6
WireConnection;33;0;25;0
WireConnection;33;1;31;0
WireConnection;50;0;45;0
WireConnection;50;1;47;0
WireConnection;48;0;42;0
WireConnection;48;1;47;4
WireConnection;24;0;28;0
WireConnection;24;1;57;0
WireConnection;0;0;33;0
WireConnection;0;1;49;0
WireConnection;0;2;24;0
WireConnection;0;3;50;0
WireConnection;0;4;48;0
WireConnection;0;10;5;4
ASEEND*/
//CHKSM=33845282C64EEB1C515E41ACA2B2A3E898B94AA3