// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tsuna/Pattern Control SS"
{
	Properties
	{
		[SingleLineTexture][Header(Main)]_MainTex("Albedo Map", 2D) = "white" {}
		_Color("Albedo Color", Color) = (1,1,1,0)
		[SingleLineTexture]_MetallicGlossMap("Metallic Map", 2D) = "white" {}
		_Metaliic("Metallic Slider", Range( 0 , 1)) = 0
		_Glossiness("Smoothness Slider", Range( 0 , 1)) = 0
		[Toggle(_)]_UseNormalMap("Use Normal Map", Float) = 0
		[Normal][SingleLineTexture]_BumpMap("Normal Map", 2D) = "bump" {}
		_NormalMapSlider("Normal Map Slider", Range( 0 , 5)) = 1
		[SingleLineTexture]_EmissionMap("Emission Map", 2D) = "black" {}
		_EmissionColor("Emission Color", Color) = (0,0,0,0)
		_TilingandOffset("Tiling and Offset", Vector) = (1,1,0,0)
		[SingleLineTexture][Header(Pattern)]_ClipTex("Pattern Map", 2D) = "white" {}
		_PatternColor("Pattern Color", Color) = (1,0,0,0)
		_Clip("Clip", Range( 0 , 1)) = 0
		_PatternTiling("Tiling and Offset", Vector) = (1,1,0,0)
		[Toggle(_)]_UseMainPat("Use MainTex on Pattern", Float) = 0
		[Toggle(_)]_EmitPattern("Use Emission on Pattern", Float) = 0
		[Header(Fresnel)][Toggle(_)]_FLimit("Toggle Fresnel Limit", Float) = 0
		_Bias("Bias", Range( 0 , 1)) = 0
		_Scale("Scale", Range( 0 , 10)) = 10
		_Power("Power", Range( 0 , 10)) = 5
		[Header(Chroma)][Toggle(_)]_ToggleChroma("Toggle Chroma", Float) = 0
		_Speed("Speed", Range( 0 , 2)) = 0
		[Header(Options)][Toggle(_)]_Invert("Invert Pattern and Fresnel", Float) = 0
		[Toggle(_)]_Togglecut("Toggle Cutout", Float) = 0
		[Header(Cull)]_CullMode("Cull Mode ( 0 = None, 1 = Front, 2 = Back)", Float) = 0
		_BackfaceDimming("Backface Dimming", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull [_CullMode]
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
			float4 screenPos;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			half ASEVFace : VFACE;
		};

		uniform float _CullMode;
		uniform float _Clip;
		uniform float _UseNormalMap;
		uniform float _NormalMapSlider;
		uniform sampler2D _BumpMap;
		uniform float4 _TilingandOffset;
		uniform float _UseMainPat;
		uniform float4 _Color;
		uniform sampler2D _MainTex;
		uniform float _ToggleChroma;
		uniform float4 _PatternColor;
		uniform float _Speed;
		uniform float _Invert;
		uniform float _FLimit;
		uniform sampler2D _ClipTex;
		uniform float4 _ClipTex_TexelSize;
		uniform float4 _PatternTiling;
		uniform float _Bias;
		uniform float _Scale;
		uniform float _Power;
		uniform float _BackfaceDimming;
		uniform float _EmitPattern;
		uniform float4 _EmissionColor;
		uniform sampler2D _EmissionMap;
		uniform float _Metaliic;
		uniform sampler2D _MetallicGlossMap;
		uniform float _Glossiness;
		uniform float _Togglecut;


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 _Vector0 = float3(0,0,1);
			float2 appendResult148 = (float2(_TilingandOffset.x , _TilingandOffset.y));
			float2 appendResult149 = (float2(_TilingandOffset.z , _TilingandOffset.w));
			float2 uv_TexCoord150 = i.uv_texcoord * appendResult148 + appendResult149;
			float3 ifLocalVar167 = 0;
			if( _UseNormalMap == 1.0 )
				ifLocalVar167 = UnpackScaleNormal( tex2D( _BumpMap, uv_TexCoord150 ), _NormalMapSlider );
			else
				ifLocalVar167 = _Vector0;
			o.Normal = ifLocalVar167;
			float4 temp_output_99_0 = ( _Color * tex2D( _MainTex, uv_TexCoord150 ) );
			float3 hsvTorgb3_g1 = HSVToRGB( float3(( _Time.y * _Speed ),1.0,1.0) );
			float4 ifLocalVar71 = 0;
			if( _ToggleChroma == 1.0 )
				ifLocalVar71 = float4( hsvTorgb3_g1 , 0.0 );
			else
				ifLocalVar71 = _PatternColor;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float2 break28 = (( _ClipTex_TexelSize * _ScreenParams * ase_grabScreenPosNorm )).xy;
			float2 appendResult98 = (float2((break28.x*_PatternTiling.x + _PatternTiling.z) , (break28.y*_PatternTiling.y + _PatternTiling.w)));
			float4 tex2DNode1 = tex2D( _ClipTex, appendResult98 );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float fresnelNdotV34 = dot( normalize( (WorldNormalVector( i , ifLocalVar167 )) ), ase_worldViewDir );
			float fresnelNode34 = ( _Bias + _Scale * pow( 1.0 - fresnelNdotV34, _Power ) );
			float ifLocalVar38 = 0;
			if( _FLimit == 1.0 )
				ifLocalVar38 = ( ( tex2DNode1.a * fresnelNode34 ) * i.ASEVFace );
			else
				ifLocalVar38 = tex2DNode1.a;
			float ifLocalVar63 = 0;
			if( _Invert == 1.0 )
				ifLocalVar63 = ( 1.0 - ifLocalVar38 );
			else
				ifLocalVar63 = ifLocalVar38;
			float4 lerpResult100 = lerp( temp_output_99_0 , ifLocalVar71 , ifLocalVar63);
			float4 ifLocalVar60 = 0;
			if( _UseMainPat == 1.0 )
				ifLocalVar60 = temp_output_99_0;
			else
				ifLocalVar60 = lerpResult100;
			float4 clampResult170 = clamp( ( ifLocalVar60 * (_BackfaceDimming + (i.ASEVFace - -1.0) * (1.0 - _BackfaceDimming) / (1.0 - -1.0)) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Albedo = clampResult170.rgb;
			float4 temp_output_78_0 = ( _EmissionColor * tex2D( _EmissionMap, uv_TexCoord150 ) );
			float4 ifLocalVar73 = 0;
			if( _EmitPattern == 1.0 )
				ifLocalVar73 = ( temp_output_78_0 + ( ifLocalVar71 * ifLocalVar63 ) );
			else
				ifLocalVar73 = temp_output_78_0;
			float4 clampResult169 = clamp( ifLocalVar73 , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Emission = clampResult169.rgb;
			float4 tex2DNode151 = tex2D( _MetallicGlossMap, uv_TexCoord150 );
			o.Metallic = ( _Metaliic * tex2DNode151 ).r;
			o.Smoothness = ( _Glossiness * tex2DNode151.a );
			o.Alpha = 1;
			float4 color56 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float4 temp_cast_4 = (ifLocalVar63).xxxx;
			float4 ifLocalVar55 = 0;
			if( _Togglecut == 1.0 )
				ifLocalVar55 = temp_cast_4;
			else
				ifLocalVar55 = color56;
			clip( ifLocalVar55.r - _Clip );
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
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
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
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
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
217.6;565.6;2156;1100;-1195.333;179.809;1;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;12;-3593.212,224.6774;Inherit;True;Property;_ClipTex;Pattern Map;11;1;[SingleLineTexture];Create;False;0;0;False;1;Header(Pattern);None;9334bda8588c8ce46a0286c2d1d4dd66;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.ScreenParams;146;-3202.383,-206.5635;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexelSizeNode;143;-3209.383,-378.5635;Inherit;False;-1;1;0;SAMPLER2D;;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GrabScreenPosition;144;-3250.766,-34.35185;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;147;-2532.727,917.0675;Inherit;False;Property;_TilingandOffset;Tiling and Offset;10;0;Create;True;0;0;False;0;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;148;-2261.726,880.738;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;149;-2264.726,1033.738;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;-2831.248,-287.006;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;150;-2076.727,927.7377;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;163;-2023.304,581.6312;Inherit;False;Property;_NormalMapSlider;Normal Map Slider;7;0;Create;True;0;0;False;0;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;26;-2444.545,-284.0382;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;168;-1915.883,-211.8444;Inherit;False;Property;_PatternTiling;Tiling and Offset;14;0;Create;False;0;0;False;0;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;28;-1922.868,-457.163;Inherit;True;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.Vector3Node;164;-1515.785,756.9201;Inherit;False;Constant;_Vector0;Vector 0;11;0;Create;True;0;0;False;0;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;165;-1547.782,450.8239;Inherit;False;Property;_UseNormalMap;Use Normal Map;5;0;Create;True;0;0;False;1;Toggle(_);0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;166;-1667.351,548.6319;Inherit;True;Property;_BumpMap;Normal Map;6;2;[Normal];[SingleLineTexture];Create;False;0;0;False;0;-1;None;76767365615d599459ecab5afc9a0bdb;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;96;-1563.981,-461.2705;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;97;-1558.78,-323.4708;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;167;-1306.56,606.2815;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1053.232,299.1895;Inherit;False;Property;_Power;Power;20;0;Create;True;0;0;False;0;5;6.352941;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;98;-1309.18,-417.0707;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-1052.232,213.1895;Inherit;False;Property;_Scale;Scale;19;0;Create;True;0;0;False;0;10;8;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;84;-928.2571,458.5203;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;49;-1056.226,132.2079;Inherit;False;Property;_Bias;Bias;18;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;34;-657.9007,169.5779;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;-0.1;False;2;FLOAT;120.19;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-998.222,-160.3174;Inherit;True;Property;_CutoutTile;Cutout Tile;1;0;Create;True;0;0;False;0;-1;050e5d60d9fe4b94c93e47cba19d0d79;050e5d60d9fe4b94c93e47cba19d0d79;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FaceVariableNode;102;-247.8249,374.9819;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-252.4538,112.8613;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-57.56934,-224.2679;Inherit;False;Property;_FLimit;Toggle Fresnel Limit;17;0;Create;False;0;0;False;2;Header(Fresnel);Toggle(_);0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;31.64307,171.0753;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;65;392.1442,467.1561;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;318.7172,591.952;Inherit;False;Property;_Speed;Speed;22;0;Create;True;0;0;False;0;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;638.9122,536.3774;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;38;293.4256,13.41714;Inherit;True;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;14;-873,-589;Inherit;False;Property;_Color;Albedo Color;1;0;Create;False;0;0;False;0;1,1,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;24;-993.8677,-406.0633;Inherit;True;Property;_MainTex;Albedo Map;0;1;[SingleLineTexture];Create;False;0;0;False;1;Header(Main);-1;None;0ad9b3b9e20ca094793ed614245a009f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;69;802.6282,95.8734;Inherit;False;Property;_ToggleChroma;Toggle Chroma;21;0;Create;True;0;0;False;2;Header(Chroma);Toggle(_);0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;302.2065,-161.3489;Inherit;False;Property;_Invert;Invert Pattern and Fresnel;23;0;Create;False;0;0;False;2;Header(Options);Toggle(_);0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;68;822.6841,554.5928;Inherit;True;Simple HUE;-1;;1;32abb5f0db087604486c2db83a2e817a;0;1;1;FLOAT;0;False;4;FLOAT3;6;FLOAT;7;FLOAT;5;FLOAT;8
Node;AmplifyShaderEditor.ColorNode;58;785.664,200.8834;Inherit;False;Property;_PatternColor;Pattern Color;12;0;Create;True;0;0;False;0;1,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;62;590.53,85.8085;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-502.9985,-548.1418;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;76;1144.069,290.3452;Inherit;True;Property;_EmissionMap;Emission Map;8;1;[SingleLineTexture];Create;False;0;0;False;0;-1;None;db0e0545abb52ea45b2375c99c78af9b;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ConditionalIfNode;71;1190.457,69.53672;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;FLOAT3;0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;63;831.1907,-108.3629;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;77;1206.225,517.2466;Inherit;False;Property;_EmissionColor;Emission Color;9;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;100;1386.637,-392.5861;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;1443.351,4.683899;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;1489.23,216.6543;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;61;1302.454,-555.6232;Inherit;False;Property;_UseMainPat;Use MainTex on Pattern;15;0;Create;False;0;0;False;1;Toggle(_);0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FaceVariableNode;161;1450.148,-885.0479;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;160;1280.712,-774.9988;Inherit;False;Property;_BackfaceDimming;Backface Dimming;26;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;60;1691.029,-544.8627;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;74;1585.146,-194.5511;Inherit;False;Property;_EmitPattern;Use Emission on Pattern;16;0;Create;False;0;0;False;1;Toggle(_);0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;159;1628.497,-836.2323;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;101;1705.698,-38.53033;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;158;2017.93,-571.8392;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;151;1116.65,836.2876;Inherit;True;Property;_MetallicGlossMap;Metallic Map;2;1;[SingleLineTexture];Create;False;0;0;False;0;-1;None;b40f8bcce7451254c8e18eed6df03b76;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;152;1133.017,1036.827;Inherit;False;Property;_Glossiness;Smoothness Slider;4;0;Create;False;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;894.2048,-295.794;Inherit;False;Property;_Togglecut;Toggle Cutout;24;0;Create;False;0;0;False;1;Toggle(_);0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;56;610.3041,-262.9614;Inherit;False;Constant;_Color0;Color 0;10;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;155;1130.15,739.9205;Inherit;False;Property;_Metaliic;Metallic Slider;3;0;Create;False;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;73;1918.965,-124.051;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;91;-531.6285,-304.7816;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0.25;False;2;FLOAT;0.9;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;153;1519.073,937.2336;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;55;1192.139,-239.0839;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;169;2535.961,264.7535;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;162;2216.477,115.7766;Inherit;False;Property;_Clip;Clip;13;0;Create;True;0;0;True;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;154;1520.288,779.8256;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;92;-487.5096,-82.53646;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;157;2185.24,-19.84445;Inherit;False;Property;_CullMode;Cull Mode ( 0 = None, 1 = Front, 2 = Back);25;0;Create;False;0;0;True;1;Header(Cull);0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;170;2533.333,133.191;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2696.376,210.287;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Tsuna/Pattern Control SS;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;157;-1;0;True;162;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;143;0;12;0
WireConnection;148;0;147;1
WireConnection;148;1;147;2
WireConnection;149;0;147;3
WireConnection;149;1;147;4
WireConnection;145;0;143;0
WireConnection;145;1;146;0
WireConnection;145;2;144;0
WireConnection;150;0;148;0
WireConnection;150;1;149;0
WireConnection;26;0;145;0
WireConnection;28;0;26;0
WireConnection;166;1;150;0
WireConnection;166;5;163;0
WireConnection;96;0;28;0
WireConnection;96;1;168;1
WireConnection;96;2;168;3
WireConnection;97;0;28;1
WireConnection;97;1;168;2
WireConnection;97;2;168;4
WireConnection;167;0;165;0
WireConnection;167;2;164;0
WireConnection;167;3;166;0
WireConnection;167;4;164;0
WireConnection;98;0;96;0
WireConnection;98;1;97;0
WireConnection;84;0;167;0
WireConnection;34;0;84;0
WireConnection;34;1;49;0
WireConnection;34;2;50;0
WireConnection;34;3;51;0
WireConnection;1;0;12;0
WireConnection;1;1;98;0
WireConnection;35;0;1;4
WireConnection;35;1;34;0
WireConnection;103;0;35;0
WireConnection;103;1;102;0
WireConnection;67;0;65;0
WireConnection;67;1;66;0
WireConnection;38;0;37;0
WireConnection;38;2;1;4
WireConnection;38;3;103;0
WireConnection;38;4;1;4
WireConnection;24;1;150;0
WireConnection;68;1;67;0
WireConnection;62;0;38;0
WireConnection;99;0;14;0
WireConnection;99;1;24;0
WireConnection;76;1;150;0
WireConnection;71;0;69;0
WireConnection;71;2;58;0
WireConnection;71;3;68;6
WireConnection;71;4;58;0
WireConnection;63;0;64;0
WireConnection;63;2;38;0
WireConnection;63;3;62;0
WireConnection;63;4;38;0
WireConnection;100;0;99;0
WireConnection;100;1;71;0
WireConnection;100;2;63;0
WireConnection;72;0;71;0
WireConnection;72;1;63;0
WireConnection;78;0;77;0
WireConnection;78;1;76;0
WireConnection;60;0;61;0
WireConnection;60;2;100;0
WireConnection;60;3;99;0
WireConnection;60;4;100;0
WireConnection;159;0;161;0
WireConnection;159;3;160;0
WireConnection;101;0;78;0
WireConnection;101;1;72;0
WireConnection;158;0;60;0
WireConnection;158;1;159;0
WireConnection;151;1;150;0
WireConnection;73;0;74;0
WireConnection;73;2;78;0
WireConnection;73;3;101;0
WireConnection;73;4;78;0
WireConnection;91;0;1;4
WireConnection;153;0;152;0
WireConnection;153;1;151;4
WireConnection;55;0;54;0
WireConnection;55;2;56;0
WireConnection;55;3;63;0
WireConnection;55;4;56;0
WireConnection;169;0;73;0
WireConnection;154;0;155;0
WireConnection;154;1;151;0
WireConnection;92;0;1;4
WireConnection;170;0;158;0
WireConnection;0;0;170;0
WireConnection;0;1;167;0
WireConnection;0;2;169;0
WireConnection;0;3;154;0
WireConnection;0;4;153;0
WireConnection;0;10;55;0
ASEEND*/
//CHKSM=A17F1711A005A37BEB2F79253E17986B79CF6036