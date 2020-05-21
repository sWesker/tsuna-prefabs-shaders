// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tsuna/Space Distortion SS"
{
	Properties
	{
		[Header(Main)]_Strength("Strength", Range( 0 , 1)) = 1
		[Toggle(_)]_Falloff("Soft Falloff", Float) = 0
		[Toggle(_)][Header(Time)]_TStrength("Timed Strength", Float) = 0
		_StrengthSpeed("Strength Speed", Range( 0 , 5)) = 0
		[Toggle(_)][Header(Filters)]_DesatSw("Desaturate", Float) = 0
		[Toggle(_)]_HueSw("Hue-ify", Float) = 0
		[Toggle(_)]_ColorSw("Colorize", Float) = 0
		_Color("Color", Color) = (0,0,0,0)
		[Toggle(_)][Header(Texture)]_ReplaceSw("Textureize", Float) = 0
		[SingleLineTexture]_MainTex("Texture Map", 2D) = "white" {}
		_Magnify("Magnify", Range( 1 , 25)) = 1
		[HideInInspector]_Nope("Nope", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ }
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
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
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float4 screenPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float _Nope;
		uniform float _Falloff;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _TStrength;
		uniform float _Strength;
		uniform float _StrengthSpeed;
		uniform float _ColorSw;
		uniform float _HueSw;
		uniform float _DesatSw;
		uniform float _ReplaceSw;
		uniform sampler2D _MainTex;
		uniform float _Magnify;
		uniform float4 _Color;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		inline float2 MyCustomExpression75( float2 uv )
		{
			return UnityStereoClamp(uv, unity_StereoScaleOffset[unity_StereoEyeIndex]);
		}


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			c.rgb = 0;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float mulTime140 = _Time.y * _StrengthSpeed;
			float ifLocalVar143 = 0;
			if( _TStrength == 1.0 )
				ifLocalVar143 = (0.0 + (sin( mulTime140 ) - -1.0) * (1.0 - 0.0) / (1.0 - -1.0));
			else
				ifLocalVar143 = _Strength;
			float fresnelNdotV27 = dot( ase_normWorldNormal, ase_worldViewDir );
			float fresnelNode27 = ( 0.0 + 0.275 * pow( 1.0 - fresnelNdotV27, ifLocalVar143 ) );
			float temp_output_39_0 = pow( ( 1.0 - fresnelNode27 ) , 30.0 );
			float2 temp_output_25_0 = (mul( UNITY_MATRIX_V, float4( ase_normWorldNormal , 0.0 ) ).xyz).xy;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float2 uv75 = ( ( temp_output_39_0 * -temp_output_25_0 ) + (ase_grabScreenPosNorm).xy );
			float2 localMyCustomExpression75 = MyCustomExpression75( uv75 );
			float4 screenColor7 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,localMyCustomExpression75);
			float temp_output_96_0 = ( 1.0 - temp_output_39_0 );
			float2 _Vector0 = float2(0.5,0.5);
			float4 ifLocalVar115 = 0;
			if( _ReplaceSw == 1.0 )
				ifLocalVar115 = tex2D( _MainTex, ( ( ( ( ( temp_output_25_0 * 0.5 ) + 0.5 ) - _Vector0 ) * _Magnify ) + _Vector0 ) );
			else
				ifLocalVar115 = screenColor7;
			float3 desaturateInitialColor47 = ifLocalVar115.rgb;
			float desaturateDot47 = dot( desaturateInitialColor47, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar47 = lerp( desaturateInitialColor47, desaturateDot47.xxx, 1.0 );
			float4 ifLocalVar112 = 0;
			if( _DesatSw == 1.0 )
				ifLocalVar112 = float4( desaturateVar47 , 0.0 );
			else
				ifLocalVar112 = ifLocalVar115;
			float3 hsvTorgb3_g1 = HSVToRGB( float3(ifLocalVar112.r,1.0,1.0) );
			float4 ifLocalVar114 = 0;
			if( _HueSw == 1.0 )
				ifLocalVar114 = float4( hsvTorgb3_g1 , 0.0 );
			else
				ifLocalVar114 = ifLocalVar112;
			float4 ifLocalVar117 = 0;
			if( _ColorSw == 1.0 )
				ifLocalVar117 = ( ifLocalVar114 * _Color );
			else
				ifLocalVar117 = ifLocalVar114;
			float4 temp_output_106_0 = ( ( screenColor7 * round( temp_output_96_0 ) ) + ( ifLocalVar117 * round( temp_output_39_0 ) ) );
			float4 ifLocalVar100 = 0;
			if( _Falloff == 1.0 )
				ifLocalVar100 = ( ( screenColor7 * temp_output_96_0 ) + ( ifLocalVar117 * temp_output_39_0 ) );
			else
				ifLocalVar100 = temp_output_106_0;
			o.Albedo = ifLocalVar100.rgb;
			o.Emission = ifLocalVar100.rgb;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting alpha:fade keepalpha fullforwardshadows noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 

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
				float4 screenPos : TEXCOORD1;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
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
231.2;270.4;1974;1279;1664.16;275.83;1.3;True;False
Node;AmplifyShaderEditor.RangedFloatNode;142;-3969.969,-822.7497;Inherit;False;Property;_StrengthSpeed;Strength Speed;3;0;Create;True;0;0;False;0;0;2.058824;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;140;-3661.918,-817.1237;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;141;-3434.614,-807.7309;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;21;-2903.378,-213.2466;Inherit;True;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewMatrixNode;33;-2808.013,8.553931;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.TFHCRemapNode;145;-3270.949,-806.0992;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-3272.549,-564.3014;Inherit;False;Property;_Strength;Strength;0;0;Create;True;0;0;False;1;Header(Main);1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;144;-3212.208,-910.6125;Inherit;False;Property;_TStrength;Timed Strength;2;0;Create;False;0;0;False;2;Toggle(_);Header(Time);0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-2498.888,-94.56739;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-2153.348,322.7;Inherit;False;Constant;_Float0;Float 0;6;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;25;-2270.36,-99.54675;Inherit;True;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;23;-2912.373,-423.2067;Float;True;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ConditionalIfNode;143;-2852.272,-715.3148;Inherit;True;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-1925.446,24.05276;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FresnelNode;27;-2253.592,-353.2769;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0.275;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;86;-1607.687,79.00037;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;11;-1846.859,-362.1403;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;134;-1354.618,921.7983;Inherit;False;Constant;_Vector0;Vector 0;10;0;Create;True;0;0;False;0;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.NegateNode;88;-1529.6,-65.7113;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;149;-1051.569,338.4974;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GrabScreenPosition;29;-1600.5,386.5243;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;39;-1583.11,-360.2046;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;30;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;129;-1007.146,995.4305;Inherit;False;Property;_Magnify;Magnify;10;0;Create;True;0;0;False;0;1;1;1;25;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1071.356,-51.76848;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;8;-1317.766,385.3889;Inherit;True;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;135;-942.6177,761.7983;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;136;-616.9009,865.9158;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;6;-832.975,62.97268;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CustomExpressionNode;75;-603.4548,80.35201;Inherit;False;UnityStereoClamp(uv, unity_StereoScaleOffset[unity_StereoEyeIndex]);2;False;1;True;uv;FLOAT2;0,0;In;;Float;False;My Custom Expression;True;False;0;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;137;-388.9009,803.9158;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-545.8566,278.906;Inherit;False;Property;_ReplaceSw;Textureize;8;0;Create;False;0;0;False;2;Toggle(_);Header(Texture);0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;110;-434.5469,465.4467;Inherit;True;Property;_MainTex;Texture Map;9;1;[SingleLineTexture];Create;False;0;0;False;0;-1;None;5f98e9e0c182c064ba33fdc751e4a1a6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;7;-371.5899,79.93924;Inherit;False;Global;_GrabScreen0;Grab Screen 0;0;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ConditionalIfNode;115;-94.46988,206.9697;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;111;160.8593,-35.92089;Inherit;False;Property;_DesatSw;Desaturate;4;0;Create;False;0;0;False;2;Toggle(_);Header(Filters);0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;47;153.0532,255.4925;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ConditionalIfNode;112;445.7892,12.7878;Inherit;True;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;FLOAT3;0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;113;918.3505,-206.3757;Inherit;False;Property;_HueSw;Hue-ify;5;0;Create;False;0;0;False;1;Toggle(_);0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;60;941.2855,132.0806;Inherit;False;Simple HUE;-1;;1;32abb5f0db087604486c2db83a2e817a;0;1;1;COLOR;0,0,0,0;False;4;FLOAT3;6;FLOAT;7;FLOAT;5;FLOAT;8
Node;AmplifyShaderEditor.ColorNode;70;1344.781,142.0693;Inherit;False;Property;_Color;Color;7;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ConditionalIfNode;114;1321.929,-85.20173;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;FLOAT3;0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;121;1588.572,-12.37597;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;118;1390.212,-253.2415;Inherit;False;Property;_ColorSw;Colorize;6;0;Create;False;0;0;False;1;Toggle(_);0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;96;-1316.508,-637.8361;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;120;3.719938,-308.0164;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;117;1802.373,-172.9275;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;119;-81.30489,-363.0323;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RoundOpNode;98;-1065.987,-390.7032;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RoundOpNode;93;-1062.299,-639.2614;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;2174.26,-40.06215;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;2163.575,-380.4129;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;2169.681,-145.3725;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;2165.102,-264.419;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;99;2158.283,-501.6148;Inherit;False;Property;_Falloff;Soft Falloff;1;0;Create;False;0;0;False;1;Toggle(_);0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;103;2426.088,-113.3215;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;106;2424.562,-330.0472;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;100;2946.894,-507.8414;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NegateNode;87;-2137.457,205.6027;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;139;3358.061,-529.0281;Inherit;False;Property;_Nope;Nope;11;1;[HideInInspector];Create;True;0;0;True;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;16;3286.767,-426.2563;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Tsuna/Space Distortion SS;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;True;139;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;140;0;142;0
WireConnection;141;0;140;0
WireConnection;145;0;141;0
WireConnection;22;0;33;0
WireConnection;22;1;21;0
WireConnection;25;0;22;0
WireConnection;143;0;144;0
WireConnection;143;2;80;0
WireConnection;143;3;145;0
WireConnection;143;4;80;0
WireConnection;84;0;25;0
WireConnection;84;1;85;0
WireConnection;27;0;21;0
WireConnection;27;4;23;0
WireConnection;27;3;143;0
WireConnection;86;0;84;0
WireConnection;86;1;85;0
WireConnection;11;0;27;0
WireConnection;88;0;25;0
WireConnection;149;0;86;0
WireConnection;39;0;11;0
WireConnection;10;0;39;0
WireConnection;10;1;88;0
WireConnection;8;0;29;0
WireConnection;135;0;149;0
WireConnection;135;1;134;0
WireConnection;136;0;135;0
WireConnection;136;1;129;0
WireConnection;6;0;10;0
WireConnection;6;1;8;0
WireConnection;75;0;6;0
WireConnection;137;0;136;0
WireConnection;137;1;134;0
WireConnection;110;1;137;0
WireConnection;7;0;75;0
WireConnection;115;0;116;0
WireConnection;115;2;7;0
WireConnection;115;3;110;0
WireConnection;115;4;7;0
WireConnection;47;0;115;0
WireConnection;112;0;111;0
WireConnection;112;2;115;0
WireConnection;112;3;47;0
WireConnection;112;4;115;0
WireConnection;60;1;112;0
WireConnection;114;0;113;0
WireConnection;114;2;112;0
WireConnection;114;3;60;6
WireConnection;114;4;112;0
WireConnection;121;0;114;0
WireConnection;121;1;70;0
WireConnection;96;0;39;0
WireConnection;120;0;7;0
WireConnection;117;0;118;0
WireConnection;117;2;114;0
WireConnection;117;3;121;0
WireConnection;117;4;114;0
WireConnection;119;0;7;0
WireConnection;98;0;39;0
WireConnection;93;0;96;0
WireConnection;102;0;117;0
WireConnection;102;1;39;0
WireConnection;105;0;119;0
WireConnection;105;1;93;0
WireConnection;101;0;120;0
WireConnection;101;1;96;0
WireConnection;104;0;117;0
WireConnection;104;1;98;0
WireConnection;103;0;101;0
WireConnection;103;1;102;0
WireConnection;106;0;105;0
WireConnection;106;1;104;0
WireConnection;100;0;99;0
WireConnection;100;2;106;0
WireConnection;100;3;103;0
WireConnection;100;4;106;0
WireConnection;16;0;100;0
WireConnection;16;2;100;0
ASEEND*/
//CHKSM=6B2631AABD23CBD48D92F153555E0923C7A87E08