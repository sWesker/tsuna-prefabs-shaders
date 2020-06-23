// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tsuna/Ghost Wire FX"
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
		[SingleLineTexture]_EmissionMap("Emission Map", 2D) = "black" {}
		[HDR]_EmissionColor("Emission Color", Color) = (0,0,0,0)
		_TilingandOffset("Tiling and Offset", Vector) = (1,1,0,0)
		[Header(Vertex Distort)]_DistortStrength("Distort Strength", Range( 0 , 1)) = 0
		_DistortScale("Distort Scale", Range( 0 , 10)) = 6.411765
		_DistortSpeed("Distort Speed", Range( 0 , 1)) = 5
		_DistortDirection("Distort Direction", Vector) = (0,0,0,0)
		[HDR][Header(Wire)]_WireColor("Wire Color", Color) = (1,1,1,0)
		_Thickness("Thickness", Range( 1 , 10)) = 5.997281
		_Gradient("Gradient", Range( 0 , 3)) = 0.9926039
		_MoveSpeed("Move Speed", Range( 0 , 1)) = 1
		_NoiseScale("Wire Scale", Range( 0 , 10)) = 6.411765
		_ScalePower("Scale Power", Range( 0 , 1)) = 1
		_ScaleSpeed("Scale Speed", Range( 0 , 1)) = 1
		_ScaleDirection("Scale Direction", Vector) = (0,0,0,0)
		[Header(Fresnel)]_Bias("Bias", Range( 0 , 1)) = 0
		_Scale("Scale", Range( 0 , 10)) = 10
		_Power("Power", Range( 0 , 10)) = 5
		[Header(Culling)]_CullMode("Cull Mode ( 0 = None, 1 = Front, 2 = Back)", Float) = 0
		_BackfaceDimming("Backface Dimming", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull [_CullMode]
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
			half ASEVFace : VFACE;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform float _ThanksforusingmyShader;
		uniform float _CullMode;
		uniform float _DistortSpeed;
		uniform float _DistortScale;
		uniform float _DistortStrength;
		uniform float3 _DistortDirection;
		uniform float _UseNormalMap;
		uniform float _NormalMapSlider;
		uniform sampler2D _BumpMap;
		uniform float4 _TilingandOffset;
		uniform float4 _Color;
		uniform sampler2D _MainTex;
		uniform float _BackfaceDimming;
		uniform sampler2D _EmissionMap;
		uniform float4 _EmissionColor;
		uniform float3 _ScaleDirection;
		uniform float _MoveSpeed;
		uniform float _NoiseScale;
		uniform float _ScaleSpeed;
		uniform float _ScalePower;
		uniform float _Thickness;
		uniform float _Gradient;
		uniform float _Bias;
		uniform float _Scale;
		uniform float _Power;
		uniform float4 _WireColor;
		uniform float _Metaliic;
		uniform sampler2D _MetallicGlossMap;
		uniform float _Glossiness;


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 appendResult71 = (float3(_Time.y , _Time.y , _Time.y));
			float simplePerlin3D52 = snoise( ( ( ase_vertex3Pos - appendResult71 ) * _DistortSpeed )*_DistortScale );
			simplePerlin3D52 = simplePerlin3D52*0.5 + 0.5;
			v.vertex.xyz += ( ( simplePerlin3D52 * _DistortStrength ) * _DistortDirection );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 _Vector0 = float3(0,0,1);
			float2 appendResult3 = (float2(_TilingandOffset.x , _TilingandOffset.y));
			float2 appendResult2 = (float2(_TilingandOffset.z , _TilingandOffset.w));
			float2 uv_TexCoord1 = i.uv_texcoord * appendResult3 + appendResult2;
			float3 ifLocalVar7 = 0;
			if( _UseNormalMap == 1.0 )
				ifLocalVar7 = UnpackScaleNormal( tex2D( _BumpMap, uv_TexCoord1 ), _NormalMapSlider );
			else
				ifLocalVar7 = _Vector0;
			o.Normal = ifLocalVar7;
			float4 clampResult16 = clamp( ( ( _Color * tex2D( _MainTex, uv_TexCoord1 ) ) * (_BackfaceDimming + (i.ASEVFace - -1.0) * (1.0 - _BackfaceDimming) / (1.0 - -1.0)) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Albedo = clampResult16.rgb;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 appendResult57 = (float3(_Time.y , _Time.y , _Time.y));
			float simplePerlin3D32 = snoise( ( ase_vertex3Pos - ( appendResult57 * _ScaleDirection * _MoveSpeed ) )*( _NoiseScale + ( sin( ( _Time.y * _ScaleSpeed ) ) * _ScalePower ) ) );
			simplePerlin3D32 = simplePerlin3D32*0.5 + 0.5;
			float temp_output_31_0 = (( 0.0 - _Thickness ) + (simplePerlin3D32 - 0.0) * (_Thickness - ( 0.0 - _Thickness )) / (1.0 - 0.0));
			float blendOpSrc40 = temp_output_31_0;
			float blendOpDest40 = ( temp_output_31_0 - _Gradient );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV46 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode46 = ( _Bias + _Scale * pow( 1.0 - fresnelNdotV46, _Power ) );
			float blendOpSrc79 = ( saturate( ( 0.5 - 2.0 * ( blendOpSrc40 - 0.5 ) * ( blendOpDest40 - 0.5 ) ) ));
			float blendOpDest79 = fresnelNode46;
			o.Emission = ( ( tex2D( _EmissionMap, uv_TexCoord1 ) * _EmissionColor * float4( ase_vertex3Pos , 0.0 ) ) + ( ( saturate( 	max( blendOpSrc79, blendOpDest79 ) )) * _WireColor ) ).rgb;
			float4 tex2DNode11 = tex2D( _MetallicGlossMap, uv_TexCoord1 );
			o.Metallic = ( _Metaliic * tex2DNode11 ).r;
			o.Smoothness = ( _Glossiness * tex2DNode11.a );
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

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
Version=18100
759.2;767.2;1317;790;1512.945;746.5981;1.385234;True;False
Node;AmplifyShaderEditor.SimpleTimeNode;58;-604.2271,-284.8237;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-748.2271,78.17627;Inherit;False;Property;_ScaleSpeed;Scale Speed;22;0;Create;True;0;0;False;0;False;1;0.363;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-385.2271,-172.8237;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;60;-226.2271,-164.8237;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;57;-405.2271,-373.8237;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-691.2271,-45.82373;Inherit;False;Property;_MoveSpeed;Move Speed;19;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-388.2271,4.17627;Inherit;False;Property;_ScalePower;Scale Power;21;0;Create;True;0;0;False;0;False;1;0.352;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;67;-586.2271,-202.8237;Inherit;False;Property;_ScaleDirection;Scale Direction;23;0;Create;True;0;0;False;0;False;0,0,0;1,1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-64.22705,-151.8237;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;41;-532.6327,-534.1943;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;33;-361.8237,-861.9946;Inherit;False;Property;_NoiseScale;Wire Scale;20;0;Create;False;0;0;False;0;False;6.411765;4.68;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-228.2271,-303.8237;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector4Node;4;-1680,208;Inherit;False;Property;_TilingandOffset;Tiling and Offset;11;0;Create;False;0;0;False;0;False;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;35;-268.922,-999.8239;Inherit;False;Property;_Thickness;Thickness;17;0;Create;True;0;0;False;0;False;5.997281;6.76;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;51.77295,-351.8237;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;59;-195.2271,-601.8237;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;2;-1424,320;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;3;-1408,176;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;36;58.27454,-1076.165;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;32;19.76336,-748.3101;Inherit;True;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;71;130.5815,-122.7142;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;51;381.0151,-1064.523;Inherit;False;Property;_Gradient;Gradient;18;0;Create;True;0;0;False;0;False;0.9926039;0;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;31;409.0872,-812.4241;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;2.33;False;4;FLOAT;-0.94;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-1232,224;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;49;678.6968,-469.8554;Inherit;False;Property;_Bias;Bias;24;0;Create;True;0;0;False;1;Header(Fresnel);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;325.8091,63.8369;Inherit;False;Property;_DistortSpeed;Distort Speed;14;0;Create;True;0;0;False;0;False;5;0.067;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;685.6907,-291.8738;Inherit;False;Property;_Power;Power;26;0;Create;True;0;0;False;0;False;5;5;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;76;555.6714,-153.2754;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;28;-1187.01,-397.6272;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;48;682.6907,-386.8738;Inherit;False;Property;_Scale;Scale;25;0;Create;True;0;0;False;0;False;10;10;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;39;776.5662,-1080.43;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1.36;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;46;1081.353,-590.3434;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;40;1084.706,-815.292;Inherit;True;Exclusion;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;423.1165,-1245.684;Inherit;False;Property;_BackfaceDimming;Backface Dimming;28;0;Create;False;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;29;-1031.01,-292.6272;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;53;1482.932,55.33071;Inherit;False;Property;_DistortScale;Distort Scale;13;0;Create;True;0;0;False;0;False;6.411765;7.88;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;23;-912,-640;Inherit;True;Property;_MainTex;Albedo Map;1;1;[SingleLineTexture];Create;False;0;0;False;1;Header(Main);False;-1;None;e093e750765e0954ca6b8960ba810dfc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;27;-832,-816;Inherit;False;Property;_Color;Albedo Color;2;0;Create;False;0;0;False;0;False;1,1,1,0;1,1,1,0.5019608;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;738.0092,-156.6631;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FaceVariableNode;20;582.1166,-1433.684;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;1825.298,80.755;Inherit;False;Property;_DistortStrength;Distort Strength;12;0;Create;True;0;0;False;1;Header(Vertex Distort);False;0;0.043;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;22;-896,-448;Inherit;True;Property;_EmissionMap;Emission Map;9;1;[SingleLineTexture];Create;False;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;30;1143.42,167.6447;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;24;-848,-240;Inherit;False;Property;_EmissionColor;Emission Color;10;1;[HDR];Create;False;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;52;1887.161,-238.7903;Inherit;True;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;896,288;Inherit;False;Property;_NormalMapSlider;Normal Map Slider;8;0;Create;False;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;19;747.1166,-1390.684;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-496,-688;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;79;1411.288,-700.2963;Inherit;True;Lighten;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;45;1463.719,-448.9012;Inherit;False;Property;_WireColor;Wire Color;16;1;[HDR];Create;True;0;0;False;1;Header(Wire);False;1,1,1,0;2.041063,3.942327,5.340315,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;6;1344,464;Inherit;False;Constant;_Vector0;Vector 0;11;0;Create;True;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;77;1945.611,168.8681;Inherit;False;Property;_DistortDirection;Distort Direction;15;0;Create;True;0;0;False;0;False;0,0,0;1,1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;1773.427,-573.6247;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;8;1200,240;Inherit;True;Property;_BumpMap;Normal Map;7;2;[Normal];[SingleLineTexture];Create;False;0;0;False;0;False;-1;None;d4f055223542df44d892584842da4f77;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;1215.813,-960.321;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;11;1057.306,-156.1118;Inherit;True;Property;_MetallicGlossMap;Metallic Map;3;1;[SingleLineTexture];Create;False;0;0;False;0;False;-1;None;cb51db7573416a84797750e06ed34b42;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;451.4885,-279.8081;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;9;1296,160;Inherit;False;Property;_UseNormalMap;Use Normal Map;6;0;Create;False;0;0;False;1;Toggle(_);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;1073.305,35.88822;Inherit;False;Property;_Glossiness;Smoothness Slider;5;0;Create;False;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;1073.305,-252.1118;Inherit;False;Property;_Metaliic;Metallic Slider;4;0;Create;False;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;2146.298,-116.245;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;1986.137,-458.9764;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;2323.131,-137.4771;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;16;1469.99,-826.5189;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;15;2540.034,-47.00628;Inherit;False;Property;_CullMode;Cull Mode ( 0 = None, 1 = Front, 2 = Back);27;0;Create;False;0;0;True;1;Header(Culling);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;1457.305,-220.1118;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;17;1914.667,-1078.287;Inherit;False;Property;_ThanksforusingmyShader;Thanks for using my Shader!;0;0;Create;False;0;0;True;5;Header(Shader by tsuna vr);Header(Discord bDWEYUw);Header(Visit for commissions and free stuff);Space(25);Toggle(_);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;7;1552,304;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;1457.305,-60.11177;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2501.831,-500.4916;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Tsuna/Ghost Wire FX;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;15;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;70;0;58;0
WireConnection;70;1;69;0
WireConnection;60;0;70;0
WireConnection;57;0;58;0
WireConnection;57;1;58;0
WireConnection;57;2;58;0
WireConnection;62;0;60;0
WireConnection;62;1;63;0
WireConnection;68;0;57;0
WireConnection;68;1;67;0
WireConnection;68;2;64;0
WireConnection;61;0;33;0
WireConnection;61;1;62;0
WireConnection;59;0;41;0
WireConnection;59;1;68;0
WireConnection;2;0;4;3
WireConnection;2;1;4;4
WireConnection;3;0;4;1
WireConnection;3;1;4;2
WireConnection;36;1;35;0
WireConnection;32;0;59;0
WireConnection;32;1;61;0
WireConnection;71;0;58;0
WireConnection;71;1;58;0
WireConnection;71;2;58;0
WireConnection;31;0;32;0
WireConnection;31;3;36;0
WireConnection;31;4;35;0
WireConnection;1;0;3;0
WireConnection;1;1;2;0
WireConnection;76;0;41;0
WireConnection;76;1;71;0
WireConnection;28;0;1;0
WireConnection;39;0;31;0
WireConnection;39;1;51;0
WireConnection;46;1;49;0
WireConnection;46;2;48;0
WireConnection;46;3;50;0
WireConnection;40;0;31;0
WireConnection;40;1;39;0
WireConnection;29;0;1;0
WireConnection;23;1;28;0
WireConnection;74;0;76;0
WireConnection;74;1;73;0
WireConnection;22;1;29;0
WireConnection;30;0;1;0
WireConnection;52;0;74;0
WireConnection;52;1;53;0
WireConnection;19;0;20;0
WireConnection;19;3;21;0
WireConnection;26;0;27;0
WireConnection;26;1;23;0
WireConnection;79;0;40;0
WireConnection;79;1;46;0
WireConnection;44;0;79;0
WireConnection;44;1;45;0
WireConnection;8;1;30;0
WireConnection;8;5;5;0
WireConnection;18;0;26;0
WireConnection;18;1;19;0
WireConnection;11;1;1;0
WireConnection;25;0;22;0
WireConnection;25;1;24;0
WireConnection;25;2;41;0
WireConnection;55;0;52;0
WireConnection;55;1;54;0
WireConnection;43;0;25;0
WireConnection;43;1;44;0
WireConnection;78;0;55;0
WireConnection;78;1;77;0
WireConnection;16;0;18;0
WireConnection;13;0;12;0
WireConnection;13;1;11;0
WireConnection;7;0;9;0
WireConnection;7;2;6;0
WireConnection;7;3;8;0
WireConnection;7;4;6;0
WireConnection;14;0;10;0
WireConnection;14;1;11;4
WireConnection;0;0;16;0
WireConnection;0;1;7;0
WireConnection;0;2;43;0
WireConnection;0;3;13;0
WireConnection;0;4;14;0
WireConnection;0;11;78;0
ASEEND*/
//CHKSM=C41077F3541D84639B214062C27530D23F5E1A4E