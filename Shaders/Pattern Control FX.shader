// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tsuna/Pattern Control FX"
{
	Properties
	{
		[Header(Shader by tsuna vr)][Header(Discord bDWEYUw)][Header(Visit for commissions and free stuff)][Space(25)][Toggle(_)]_ThanksforusingmyShader("Thanks for using my Shader!", Float) = 0
		[SingleLineTexture][Header(Main)]_MainTex("Albedo Map", 2D) = "white" {}
		_Color("Albedo Color", Color) = (1,1,1,0)
		[SingleLineTexture]_MetallicGlossMap("Metallic Map", 2D) = "white" {}
		_Metaliic("Metallic Slider", Range( 0 , 1)) = 0
		_Glossiness("Smoothness Slider", Range( 0 , 1)) = 0
		[Toggle(_)]_UseNormalMap("Use Normal Map", Float) = 0
		[Normal][SingleLineTexture]_BumpMap("Normal Map", 2D) = "bump" {}
		_NormalMapSlider("Normal Map Slider", Range( 0 , 5)) = 1
		[SingleLineTexture]_EmissionMap("EmissionMap", 2D) = "black" {}
		_EmissionColor("EmissionColor", Color) = (0,0,0,0)
		_TilingandOffset("Tiling and Offset", Vector) = (1,1,0,0)
		[SingleLineTexture][Header(Pattern)]_ClipTex("Pattern Map", 2D) = "white" {}
		_PatternColor("Pattern Color", Color) = (1,0,0,0)
		_Clip("Clip", Range( 0 , 1)) = 0.5
		_PatternTiling("Tilling and Offset", Vector) = (1,1,0,0)
		[Toggle(_)]_UseMainPat("Use Albedo Map on Pattern", Float) = 0
		[Toggle(_)]_UseMainPat1("Use Pattern Map on Pattern", Float) = 0
		[Toggle]_EmitPattern("Use Emission on Pattern", Float) = 0
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
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			half ASEVFace : VFACE;
		};

		uniform float _Clip;
		uniform float _CullMode;
		uniform float _ThanksforusingmyShader;
		uniform float _UseNormalMap;
		uniform float _NormalMapSlider;
		uniform sampler2D _BumpMap;
		uniform float4 _TilingandOffset;
		uniform float _UseMainPat1;
		uniform float _UseMainPat;
		uniform float4 _Color;
		uniform sampler2D _MainTex;
		uniform float _ToggleChroma;
		uniform float4 _PatternColor;
		uniform float _Speed;
		uniform float _Invert;
		uniform float _FLimit;
		uniform sampler2D _ClipTex;
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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 _Vector0 = float3(0,0,1);
			float2 appendResult126 = (float2(_TilingandOffset.x , _TilingandOffset.y));
			float2 appendResult127 = (float2(_TilingandOffset.z , _TilingandOffset.w));
			float2 uv_TexCoord128 = i.uv_texcoord * appendResult126 + appendResult127;
			float3 ifLocalVar122 = 0;
			if( _UseNormalMap == 1.0 )
				ifLocalVar122 = UnpackScaleNormal( tex2D( _BumpMap, uv_TexCoord128 ), _NormalMapSlider );
			else
				ifLocalVar122 = _Vector0;
			o.Normal = ifLocalVar122;
			float4 tex2DNode24 = tex2D( _MainTex, uv_TexCoord128 );
			float4 temp_output_99_0 = ( _Color * tex2DNode24 );
			float3 hsvTorgb3_g1 = HSVToRGB( float3(( _Time.y * _Speed ),1.0,1.0) );
			float4 ifLocalVar71 = 0;
			if( _ToggleChroma == 1.0 )
				ifLocalVar71 = float4( hsvTorgb3_g1 , 0.0 );
			else
				ifLocalVar71 = _PatternColor;
			float2 appendResult143 = (float2(_PatternTiling.x , _PatternTiling.y));
			float2 appendResult142 = (float2(_PatternTiling.z , _PatternTiling.w));
			float2 uv_TexCoord17 = i.uv_texcoord * appendResult143 + appendResult142;
			float4 tex2DNode1 = tex2D( _ClipTex, uv_TexCoord17 );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float fresnelNdotV34 = dot( normalize( (WorldNormalVector( i , ifLocalVar122 )) ), ase_worldViewDir );
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
			float4 ifLocalVar148 = 0;
			if( _UseMainPat1 == 1.0 )
				ifLocalVar148 = ( ( temp_output_99_0 * ( 1.0 - ifLocalVar63 ) ) + ( tex2DNode1 * ifLocalVar63 ) );
			else
				ifLocalVar148 = ifLocalVar60;
			float4 clampResult155 = clamp( ( ifLocalVar148 * (_BackfaceDimming + (i.ASEVFace - -1.0) * (1.0 - _BackfaceDimming) / (1.0 - -1.0)) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Albedo = clampResult155.rgb;
			float4 temp_output_78_0 = ( _EmissionColor * tex2D( _EmissionMap, uv_TexCoord128 ) );
			float4 ifLocalVar73 = 0;
			if( _EmitPattern == 1.0 )
				ifLocalVar73 = ( temp_output_78_0 + ( ifLocalVar71 * ifLocalVar63 ) );
			else
				ifLocalVar73 = temp_output_78_0;
			float4 clampResult154 = clamp( ifLocalVar73 , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Emission = clampResult154.rgb;
			float4 tex2DNode137 = tex2D( _MetallicGlossMap, uv_TexCoord128 );
			o.Metallic = ( _Metaliic * tex2DNode137 ).r;
			o.Smoothness = ( _Glossiness * tex2DNode137.a );
			o.Alpha = 1;
			float4 color56 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float4 temp_cast_4 = (ifLocalVar63).xxxx;
			float4 ifLocalVar55 = 0;
			if( _Togglecut == 1.0 )
				ifLocalVar55 = temp_cast_4;
			else
				ifLocalVar55 = color56;
			clip( ( ifLocalVar55 * tex2DNode24.a ).r - _Clip );
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
217.6;565.6;2156;1100;-1470.297;103.9961;1;True;False
Node;AmplifyShaderEditor.Vector4Node;125;47.55705,967.5449;Inherit;False;Property;_TilingandOffset;Tiling and Offset;11;0;Create;True;0;0;False;0;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;127;315.5571,1084.215;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;126;318.5571,931.2152;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;128;503.557,978.2149;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;113;-1880.942,583.4578;Inherit;False;Property;_NormalMapSlider;Normal Map Slider;8;0;Create;True;0;0;False;0;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;114;711.298,852.1114;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;119;-1468.704,447.2653;Inherit;False;Property;_UseNormalMap;Use Normal Map;6;0;Create;True;0;0;False;1;Toggle(_);0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;117;-1586.922,545.0731;Inherit;True;Property;_BumpMap;Normal Map;7;2;[Normal];[SingleLineTexture];Create;False;0;0;False;0;-1;None;76767365615d599459ecab5afc9a0bdb;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;118;-1435.356,753.3613;Inherit;False;Constant;_Vector0;Vector 0;11;0;Create;True;0;0;False;0;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector4Node;144;-1939.261,-369.9911;Inherit;False;Property;_PatternTiling;Tilling and Offset;15;0;Create;False;0;0;False;0;1,1,0,0;10,10,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ConditionalIfNode;122;-1226.131,602.7227;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;143;-1668.261,-406.3209;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;142;-1671.261,-253.3211;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1056.226,130.2079;Inherit;False;Property;_Bias;Bias;20;0;Create;True;0;0;False;0;0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;12;-1470.158,-164.8569;Inherit;True;Property;_ClipTex;Pattern Map;12;1;[SingleLineTexture];Create;False;0;0;False;1;Header(Pattern);None;9334bda8588c8ce46a0286c2d1d4dd66;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1053.232,299.1895;Inherit;False;Property;_Power;Power;22;0;Create;True;0;0;False;0;5;2;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-1480.788,-357.633;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;84;-928.2571,458.5203;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;50;-1052.232,213.1895;Inherit;False;Property;_Scale;Scale;21;0;Create;True;0;0;False;0;10;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;34;-657.9007,169.5779;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;-0.1;False;2;FLOAT;120.19;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-998.222,-160.3174;Inherit;True;Property;_CutoutTile;Cutout Tile;1;0;Create;True;0;0;False;0;-1;050e5d60d9fe4b94c93e47cba19d0d79;050e5d60d9fe4b94c93e47cba19d0d79;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-252.4538,112.8613;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FaceVariableNode;102;-247.8249,374.9819;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;31.64307,171.0753;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-57.56934,-224.2679;Inherit;False;Property;_FLimit;Toggle Fresnel Limit;19;0;Create;False;0;0;False;2;Header(Fresnel);Toggle(_);0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;318.7172,591.952;Inherit;False;Property;_Speed;Speed;24;0;Create;True;0;0;False;0;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;65;392.1442,467.1561;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;38;293.4256,12.41714;Inherit;True;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;136;-648.0571,763.3011;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;135;-1278.333,301.2766;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;638.9122,536.3774;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;298.8267,-164.2892;Inherit;False;Property;_Invert;Invert Pattern and Fresnel;25;0;Create;False;0;0;False;2;Header(Options);Toggle(_);0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;62;590.53,85.8085;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;58;785.664,200.8834;Inherit;False;Property;_PatternColor;Pattern Color;13;0;Create;False;0;0;False;0;1,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;24;-993.8677,-406.0633;Inherit;True;Property;_MainTex;Albedo Map;1;1;[SingleLineTexture];Create;False;0;0;False;1;Header(Main);-1;None;0ad9b3b9e20ca094793ed614245a009f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;69;802.6282,94.33207;Inherit;False;Property;_ToggleChroma;Toggle Chroma;23;0;Create;True;0;0;False;2;Header(Chroma);Toggle(_);0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;14;-906.0885,-589;Inherit;False;Property;_Color;Albedo Color;2;0;Create;False;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;68;822.6841,554.5928;Inherit;True;Simple HUE;-1;;1;32abb5f0db087604486c2db83a2e817a;0;1;1;FLOAT;0;False;4;FLOAT3;6;FLOAT;7;FLOAT;5;FLOAT;8
Node;AmplifyShaderEditor.ConditionalIfNode;63;794.1907,-89.36292;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;71;1190.457,69.53672;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;FLOAT3;0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;152;551.5084,-631.781;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-502.9985,-548.1418;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;134;1048.224,766.0881;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;149;780.5861,-477.3875;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;100;1380.637,-326.5861;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;798.5084,-660.781;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;76;1144.069,290.3452;Inherit;True;Property;_EmissionMap;EmissionMap;9;1;[SingleLineTexture];Create;True;0;0;False;0;-1;None;db0e0545abb52ea45b2375c99c78af9b;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;61;1380.695,-563.1962;Inherit;False;Property;_UseMainPat;Use Albedo Map on Pattern;16;0;Create;False;0;0;False;1;Toggle(_);0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;77;1221.825,517.2466;Inherit;False;Property;_EmissionColor;EmissionColor;10;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ConditionalIfNode;60;1739.086,-534.5759;Inherit;True;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;111;1348.119,-649.5265;Inherit;False;Property;_BackfaceDimming;Backface Dimming;28;0;Create;True;0;0;False;0;0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;1489.23,216.6543;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;147;1707.167,-823.0721;Inherit;False;Property;_UseMainPat1;Use Pattern Map on Pattern;17;0;Create;False;0;0;False;1;Toggle(_);0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;150;1002.508,-578.781;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;1443.351,4.683899;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FaceVariableNode;105;1517.555,-759.5756;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;894.2048,-295.794;Inherit;False;Property;_Togglecut;Toggle Cutout;26;0;Create;False;0;0;False;1;Toggle(_);0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;56;589.3041,-272.9614;Inherit;False;Constant;_Color0;Color 0;10;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;101;1705.698,-38.53033;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;109;1695.904,-710.76;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;148;2134.555,-493.1753;Inherit;True;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;74;1671.146,-242.0942;Inherit;False;Property;_EmitPattern;Use Emission on Pattern;18;1;[Toggle];Create;False;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;138;1346.424,1052.299;Inherit;False;Property;_Glossiness;Smoothness Slider;5;0;Create;False;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;137;1330.057,851.7599;Inherit;True;Property;_MetallicGlossMap;Metallic Map;3;1;[SingleLineTexture];Create;False;0;0;False;0;-1;None;b40f8bcce7451254c8e18eed6df03b76;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ConditionalIfNode;55;1135.139,-202.0839;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;73;1918.965,-124.051;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;2432.447,-551.4536;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;139;1343.557,755.3927;Inherit;False;Property;_Metaliic;Metallic Slider;4;0;Create;False;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;154;2845.297,434.0039;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;1732.48,952.706;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;153;-64968.42,43285.34;Inherit;False;Property;_ThanksforusingmyShader;Thanks for using my Shader!;0;0;Create;True;0;0;True;5;Header(Shader by tsuna vr);Header(Discord bDWEYUw);Header(Visit for commissions and free stuff);Space(25);Toggle(_);0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;145;2383.463,290.3438;Inherit;False;Property;_Clip;Clip;14;0;Create;True;0;0;True;0;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;2011.174,348.1008;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;110;2374.646,193.6278;Inherit;False;Property;_CullMode;Cull Mode ( 0 = None, 1 = Front, 2 = Back);27;0;Create;False;0;0;True;1;Header(Cull);0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;1733.695,795.2977;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;155;2842.297,273.0039;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3019.138,389.007;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Tsuna/Pattern Control FX;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;110;-1;0;True;145;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;127;0;125;3
WireConnection;127;1;125;4
WireConnection;126;0;125;1
WireConnection;126;1;125;2
WireConnection;128;0;126;0
WireConnection;128;1;127;0
WireConnection;114;0;128;0
WireConnection;117;1;114;0
WireConnection;117;5;113;0
WireConnection;122;0;119;0
WireConnection;122;2;118;0
WireConnection;122;3;117;0
WireConnection;122;4;118;0
WireConnection;143;0;144;1
WireConnection;143;1;144;2
WireConnection;142;0;144;3
WireConnection;142;1;144;4
WireConnection;17;0;143;0
WireConnection;17;1;142;0
WireConnection;84;0;122;0
WireConnection;34;0;84;0
WireConnection;34;1;49;0
WireConnection;34;2;50;0
WireConnection;34;3;51;0
WireConnection;1;0;12;0
WireConnection;1;1;17;0
WireConnection;35;0;1;4
WireConnection;35;1;34;0
WireConnection;103;0;35;0
WireConnection;103;1;102;0
WireConnection;38;0;37;0
WireConnection;38;2;1;4
WireConnection;38;3;103;0
WireConnection;38;4;1;4
WireConnection;136;0;128;0
WireConnection;135;0;136;0
WireConnection;67;0;65;0
WireConnection;67;1;66;0
WireConnection;62;0;38;0
WireConnection;24;1;135;0
WireConnection;68;1;67;0
WireConnection;63;0;64;0
WireConnection;63;2;38;0
WireConnection;63;3;62;0
WireConnection;63;4;38;0
WireConnection;71;0;69;0
WireConnection;71;2;58;0
WireConnection;71;3;68;6
WireConnection;71;4;58;0
WireConnection;152;0;63;0
WireConnection;99;0;14;0
WireConnection;99;1;24;0
WireConnection;134;0;128;0
WireConnection;149;0;1;0
WireConnection;149;1;63;0
WireConnection;100;0;99;0
WireConnection;100;1;71;0
WireConnection;100;2;63;0
WireConnection;151;0;99;0
WireConnection;151;1;152;0
WireConnection;76;1;134;0
WireConnection;60;0;61;0
WireConnection;60;2;100;0
WireConnection;60;3;99;0
WireConnection;60;4;100;0
WireConnection;78;0;77;0
WireConnection;78;1;76;0
WireConnection;150;0;151;0
WireConnection;150;1;149;0
WireConnection;72;0;71;0
WireConnection;72;1;63;0
WireConnection;101;0;78;0
WireConnection;101;1;72;0
WireConnection;109;0;105;0
WireConnection;109;3;111;0
WireConnection;148;0;147;0
WireConnection;148;2;60;0
WireConnection;148;3;150;0
WireConnection;148;4;60;0
WireConnection;137;1;128;0
WireConnection;55;0;54;0
WireConnection;55;2;56;0
WireConnection;55;3;63;0
WireConnection;55;4;56;0
WireConnection;73;0;74;0
WireConnection;73;2;78;0
WireConnection;73;3;101;0
WireConnection;73;4;78;0
WireConnection;104;0;148;0
WireConnection;104;1;109;0
WireConnection;154;0;73;0
WireConnection;141;0;138;0
WireConnection;141;1;137;4
WireConnection;146;0;55;0
WireConnection;146;1;24;4
WireConnection;140;0;139;0
WireConnection;140;1;137;0
WireConnection;155;0;104;0
WireConnection;0;0;155;0
WireConnection;0;1;122;0
WireConnection;0;2;154;0
WireConnection;0;3;140;0
WireConnection;0;4;141;0
WireConnection;0;10;146;0
ASEEND*/
//CHKSM=EF6F51B3354DC392EA28B6856D76E19D42C7E249