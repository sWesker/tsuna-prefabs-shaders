// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tsuna/Normal Hell FX"
{
	Properties
	{
		[SingleLineTexture][Header(Main)]_MainTex("Albedo Map", 2D) = "white" {}
		_Color("Albedo Color", Color) = (0,0,0,0)
		[SingleLineTexture]_MetallicGlossMap("Metallic Map", 2D) = "white" {}
		_Metaliic("Metallic Slider", Range( 0 , 1)) = 0
		_Glossiness("Smoothness Slider", Range( 0 , 1)) = 0
		[Toggle(_)]_UseNormalMap("Use Normal Map", Float) = 0
		[Normal][SingleLineTexture]_BumpMap("Normal Map", 2D) = "bump" {}
		_NormalMapSlider("Normal Map Slider", Range( 0 , 5)) = 1
		_TilingandOffset("Tiling and Offset", Vector) = (1,1,0,0)
		[Header(Hell)]_Speed("Speed", Range( 0 , 0.05)) = 1
		_Strength("Strength", Range( 0 , 0.05)) = 0.1
		[Header(Chroma)][Toggle(_)]_ToggleChroma("Toggle Chroma", Float) = 0
		_ChromaSpeed1("Speed", Range( 0 , 2)) = 0
		_ChromaSpeed2("Strength", Range( 0 , 2)) = 0
		[Header(Cull)]_BackfaceDimming("Backface Dimming", Range( 0 , 1)) = 0
		_Cull("Cull Mode ( 0 = None, 1 = Front, 2 = Back)", Float) = 2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull [_Cull]
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
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
			float3 worldNormal;
			INTERNAL_DATA
			half ASEVFace : VFACE;
		};

		uniform float _Cull;
		uniform float _Strength;
		uniform float _Speed;
		uniform float4 _TilingandOffset;
		uniform float _UseNormalMap;
		uniform float _NormalMapSlider;
		uniform sampler2D _BumpMap;
		uniform float _ToggleChroma;
		uniform sampler2D _MainTex;
		uniform float4 _Color;
		uniform float _ChromaSpeed1;
		uniform float _ChromaSpeed2;
		uniform float _BackfaceDimming;
		uniform float _Metaliic;
		uniform sampler2D _MetallicGlossMap;
		uniform float _Glossiness;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 temp_cast_0 = (_Speed).xx;
			float2 appendResult38 = (float2(_TilingandOffset.x , _TilingandOffset.y));
			float2 appendResult37 = (float2(_TilingandOffset.z , _TilingandOffset.w));
			float2 uv_TexCoord39 = v.texcoord.xy * appendResult38 + appendResult37;
			float2 panner16 = ( _Time.y * temp_cast_0 + uv_TexCoord39);
			float simplePerlin2D6 = snoise( panner16*_Time.y );
			simplePerlin2D6 = simplePerlin2D6*0.5 + 0.5;
			float3 _Vector0 = float3(0,0,1);
			float3 ifLocalVar51 = 0;
			if( _UseNormalMap == 1.0 )
				ifLocalVar51 = UnpackScaleNormal( tex2Dlod( _BumpMap, float4( uv_TexCoord39, 0, 0.0) ), _NormalMapSlider );
			else
				ifLocalVar51 = _Vector0;
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float3 ase_worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
			float3x3 tangentToWorld = CreateTangentToWorldPerVertex( ase_worldNormal, ase_worldTangent, v.tangent.w );
			float3 tangentNormal13 = ifLocalVar51;
			float3 modWorldNormal13 = (tangentToWorld[0] * tangentNormal13.x + tangentToWorld[1] * tangentNormal13.y + tangentToWorld[2] * tangentNormal13.z);
			v.vertex.xyz += ( _Strength * simplePerlin2D6 * modWorldNormal13 );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 _Vector0 = float3(0,0,1);
			float2 appendResult38 = (float2(_TilingandOffset.x , _TilingandOffset.y));
			float2 appendResult37 = (float2(_TilingandOffset.z , _TilingandOffset.w));
			float2 uv_TexCoord39 = i.uv_texcoord * appendResult38 + appendResult37;
			float3 ifLocalVar51 = 0;
			if( _UseNormalMap == 1.0 )
				ifLocalVar51 = UnpackScaleNormal( tex2D( _BumpMap, uv_TexCoord39 ), _NormalMapSlider );
			else
				ifLocalVar51 = _Vector0;
			o.Normal = ifLocalVar51;
			float3 newWorldNormal13 = (WorldNormalVector( i , ifLocalVar51 ));
			float2 temp_cast_1 = (_Speed).xx;
			float2 panner16 = ( _Time.y * temp_cast_1 + uv_TexCoord39);
			float simplePerlin2D6 = snoise( panner16*_Time.y );
			simplePerlin2D6 = simplePerlin2D6*0.5 + 0.5;
			float4 temp_output_15_0 = ( tex2D( _MainTex, uv_TexCoord39 ) * float4( newWorldNormal13 , 0.0 ) * simplePerlin2D6 * _Color );
			float mulTime74 = _Time.y * _ChromaSpeed1;
			float3 hsvTorgb3_g1 = HSVToRGB( float3(( mulTime74 + temp_output_15_0 ).r,1.0,1.0) );
			float4 lerpResult92 = lerp( temp_output_15_0 , float4( hsvTorgb3_g1 , 0.0 ) , _ChromaSpeed2);
			float4 ifLocalVar76 = 0;
			if( _ToggleChroma == 1.0 )
				ifLocalVar76 = lerpResult92;
			else
				ifLocalVar76 = temp_output_15_0;
			float4 clampResult93 = clamp( ( ifLocalVar76 * (_BackfaceDimming + (i.ASEVFace - -1.0) * (1.0 - _BackfaceDimming) / (1.0 - -1.0)) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Albedo = clampResult93.rgb;
			o.Emission = clampResult93.rgb;
			float4 tex2DNode49 = tex2D( _MetallicGlossMap, uv_TexCoord39 );
			o.Metallic = ( _Metaliic * tex2DNode49 ).r;
			o.Smoothness = ( _Glossiness * tex2DNode49.a );
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd vertex:vertexDataFunc 

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
				vertexDataFunc( v, customInputData );
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
217.6;565.6;2156;1100;169.9057;178.8405;1;True;False
Node;AmplifyShaderEditor.Vector4Node;36;-1209.66,1024.46;Inherit;False;Property;_TilingandOffset;Tiling and Offset;8;0;Create;True;0;0;False;0;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;37;-941.6597,1138.46;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;38;-938.6597,985.4603;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-753.6596,1032.46;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;43;-324.0643,1393.497;Inherit;False;Property;_NormalMapSlider;Normal Map Slider;7;0;Create;True;0;0;False;0;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;42;-437.0813,1321.752;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;45;121.5224,1563.401;Inherit;False;Constant;_Vector0;Vector 0;11;0;Create;True;0;0;False;0;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;46;-11.76694,1347.498;Inherit;True;Property;_BumpMap;Normal Map;6;2;[Normal];[SingleLineTexture];Create;False;0;0;False;0;-1;None;76767365615d599459ecab5afc9a0bdb;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;48;87.17364,1260.391;Inherit;False;Property;_UseNormalMap;Use Normal Map;5;0;Create;True;0;0;False;1;Toggle(_);0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;72;-466.8907,904.0516;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ConditionalIfNode;51;330.7465,1412.762;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;1;-1735.679,225.068;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;71;-1274.94,851.4667;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;70;390.5899,1196.674;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1726.544,545.225;Inherit;False;Property;_Speed;Speed;9;0;Create;True;0;0;False;1;Header(Hell);1;0;0;0.05;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;16;-1228.215,462.0418;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;69;-347.347,1121.302;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;6;-871.5037,416.462;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1000;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;90;-568.0596,-185.5398;Inherit;False;Property;_Color;Albedo Color;1;0;Create;False;0;0;False;0;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;75;-837.9602,-282.0444;Inherit;False;Property;_ChromaSpeed1;Speed;12;0;Create;False;0;0;False;0;0;0.112;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;13;-306.2121,612.4541;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;14;-633.2126,10.48247;Inherit;True;Property;_MainTex;Albedo Map;0;1;[SingleLineTexture];Create;False;0;0;False;1;Header(Main);-1;None;0ad9b3b9e20ca094793ed614245a009f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-285.8531,100.1705;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;74;-350.4529,-289.8326;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FaceVariableNode;34;563.8503,-89.83795;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;88;27.90025,-3.08918;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;32;403.409,-233.4344;Inherit;False;Property;_BackfaceDimming;Backface Dimming;14;0;Create;True;0;0;False;1;Header(Cull);0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-96.24732,-215.9704;Inherit;False;Property;_ChromaSpeed2;Strength;13;0;Create;False;0;0;False;0;0;0.112;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;33;745.7975,-84.19584;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;73;37.26099,205.4161;Inherit;True;Simple HUE;-1;;1;32abb5f0db087604486c2db83a2e817a;0;1;1;COLOR;0,0,0,0;False;4;FLOAT3;6;FLOAT;7;FLOAT;5;FLOAT;8
Node;AmplifyShaderEditor.RangedFloatNode;77;308.6923,-125.1322;Inherit;False;Property;_ToggleChroma;Toggle Chroma;11;0;Create;True;0;0;False;2;Header(Chroma);Toggle(_);0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;92;328.8528,68.22955;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;86;997.416,14.72439;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;87;742.5275,183.1722;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;76;563.5754,120.2292;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-232.8506,1066.886;Inherit;False;Property;_Glossiness;Smoothness Slider;4;0;Create;False;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;49;-249.2176,866.3463;Inherit;True;Property;_MetallicGlossMap;Metallic Map;2;1;[SingleLineTexture];Create;False;0;0;False;0;-1;None;b40f8bcce7451254c8e18eed6df03b76;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;47;-241.6456,774.7256;Inherit;False;Property;_Metaliic;Metallic Slider;3;0;Create;False;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;800.8254,222.7529;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-354.3287,465.8792;Inherit;False;Property;_Strength;Strength;10;0;Create;True;0;0;False;0;0.1;0.0138;0;0.05;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;154.4207,809.8842;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;68;628.9737,1224.719;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;93;960.0942,222.1595;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;153.2055,967.2925;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;264.6029,440.8336;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;31;969.3994,121.3293;Inherit;False;Property;_Cull;Cull Mode ( 0 = None, 1 = Front, 2 = Back);15;0;Create;False;0;0;True;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1169.917,205.9299;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Tsuna/Normal Hell FX;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;31;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;37;0;36;3
WireConnection;37;1;36;4
WireConnection;38;0;36;1
WireConnection;38;1;36;2
WireConnection;39;0;38;0
WireConnection;39;1;37;0
WireConnection;42;0;39;0
WireConnection;46;1;42;0
WireConnection;46;5;43;0
WireConnection;72;0;39;0
WireConnection;51;0;48;0
WireConnection;51;2;45;0
WireConnection;51;3;46;0
WireConnection;51;4;45;0
WireConnection;71;0;72;0
WireConnection;70;0;51;0
WireConnection;16;0;71;0
WireConnection;16;2;3;0
WireConnection;16;1;1;0
WireConnection;69;0;70;0
WireConnection;6;0;16;0
WireConnection;6;1;1;0
WireConnection;13;0;69;0
WireConnection;14;1;39;0
WireConnection;15;0;14;0
WireConnection;15;1;13;0
WireConnection;15;2;6;0
WireConnection;15;3;90;0
WireConnection;74;0;75;0
WireConnection;88;0;74;0
WireConnection;88;1;15;0
WireConnection;33;0;34;0
WireConnection;33;3;32;0
WireConnection;73;1;88;0
WireConnection;92;0;15;0
WireConnection;92;1;73;6
WireConnection;92;2;91;0
WireConnection;86;0;33;0
WireConnection;87;0;86;0
WireConnection;76;0;77;0
WireConnection;76;2;15;0
WireConnection;76;3;92;0
WireConnection;76;4;15;0
WireConnection;49;1;39;0
WireConnection;35;0;76;0
WireConnection;35;1;87;0
WireConnection;52;0;47;0
WireConnection;52;1;49;0
WireConnection;68;0;51;0
WireConnection;93;0;35;0
WireConnection;50;0;44;0
WireConnection;50;1;49;4
WireConnection;10;0;12;0
WireConnection;10;1;6;0
WireConnection;10;2;13;0
WireConnection;0;0;93;0
WireConnection;0;1;68;0
WireConnection;0;2;93;0
WireConnection;0;3;52;0
WireConnection;0;4;50;0
WireConnection;0;11;10;0
ASEEND*/
//CHKSM=105B5A66354DE9577037B2A31EF911D8305F7C8D