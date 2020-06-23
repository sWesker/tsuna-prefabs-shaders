// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tsuna/Slime FX"
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
		[SingleLineTexture]_EmissionMap("Emission Map", 2D) = "white" {}
		[HDR]_EmissionColor("Emission Color", Color) = (0,0,0,0)
		_TilingandOffset("Tiling and Offset", Vector) = (1,1,0,0)
		[Header(Blending)]_Transparency("Transparency", Range( 0 , 1)) = 0
		_Refaction("Refaction", Range( -10 , 10)) = 1
		[HideInInspector]_Clip("Clip", Float) = 0.5
		[Toggle(_)][Header(Matcap)]_ToggleMatcap("Toggle Matcap", Float) = 0
		[SingleLineTexture]_MatcapMap("Matcap Map", 2D) = "white" {}
		_MatcapColor("Matcap Color", Color) = (1,1,1,0)
		_MatcapStrength("Matcap Strength", Range( 0 , 10)) = 1
		[Toggle(_)]_MatcapMode("Matcap Mode", Float) = 0
		[Header(Vertex Distort)]_DistortStrength("Distort Strength", Range( 0 , 1)) = 1
		_DistortSpeed("Distort Speed", Range( 0 , 1)) = 1
		_DistortScale("Distort Scale", Range( 0 , 10)) = 6.411765
		_DistortDirection("Distort Direction", Vector) = (0,0,0,0)
		[Header(Culling)]_CullMode("Cull Mode ( 0 = None, 1 = Front, 2 = Back)", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull [_CullMode]
		Blend SrcAlpha OneMinusSrcAlpha
		
		GrabPass{ }
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
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
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float4 screenPos;
		};

		uniform float _ThanksforusingmyShader;
		uniform float _Clip;
		uniform float _CullMode;
		uniform float _DistortSpeed;
		uniform float _DistortScale;
		uniform float _DistortStrength;
		uniform float3 _DistortDirection;
		uniform float _UseNormalMap;
		uniform float _NormalMapSlider;
		uniform sampler2D _BumpMap;
		uniform float4 _TilingandOffset;
		uniform float _ToggleMatcap;
		uniform float4 _Color;
		uniform sampler2D _MainTex;
		uniform float _MatcapMode;
		uniform sampler2D _MatcapMap;
		uniform float _MatcapStrength;
		uniform float4 _MatcapColor;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _Refaction;
		uniform float _Transparency;
		uniform sampler2D _EmissionMap;
		uniform float4 _EmissionColor;
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


		float2 matcapSample140( float3 viewDirection , float3 normalDirection )
		{
			half3 worldUp = float3(0,1,0);
			half3 worldViewUp = normalize(worldUp - viewDirection * dot(viewDirection, worldUp));
			half3 worldViewRight = normalize(cross(viewDirection, worldViewUp));
			half2 matcapUV = half2(dot(worldViewRight, normalDirection), dot(worldViewUp, normalDirection)) * 0.5 + 0.5;
			return matcapUV;
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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 appendResult158 = (float3(_Time.y , _Time.y , _Time.y));
			float simplePerlin3D151 = snoise( ( ( ase_vertex3Pos - appendResult158 ) * _DistortSpeed )*_DistortScale );
			simplePerlin3D151 = simplePerlin3D151*0.5 + 0.5;
			v.vertex.xyz += ( ( simplePerlin3D151 * _DistortStrength ) * _DistortDirection );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 _Vector0 = float3(0,0,1);
			float2 appendResult77 = (float2(_TilingandOffset.x , _TilingandOffset.y));
			float2 appendResult76 = (float2(_TilingandOffset.z , _TilingandOffset.w));
			float2 uv_TexCoord78 = i.uv_texcoord * appendResult77 + appendResult76;
			float3 ifLocalVar114 = 0;
			if( _UseNormalMap == 1.0 )
				ifLocalVar114 = UnpackScaleNormal( tex2D( _BumpMap, uv_TexCoord78 ), _NormalMapSlider );
			else
				ifLocalVar114 = _Vector0;
			o.Normal = ifLocalVar114;
			float4 temp_output_86_0 = ( _Color * tex2D( _MainTex, uv_TexCoord78 ) );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 viewDirection140 = ase_worldViewDir;
			float3 newWorldNormal143 = (WorldNormalVector( i , ifLocalVar114 ));
			float3 normalDirection140 = newWorldNormal143;
			float2 localmatcapSample140 = matcapSample140( viewDirection140 , normalDirection140 );
			float4 temp_output_30_0 = ( tex2D( _MatcapMap, localmatcapSample140 ) * _MatcapStrength * _MatcapColor );
			float4 temp_output_32_0 = ( temp_output_30_0 * temp_output_86_0 );
			float4 ifLocalVar126 = 0;
			if( _MatcapMode == 1.0 )
				ifLocalVar126 = ( temp_output_30_0 + temp_output_86_0 );
			else
				ifLocalVar126 = temp_output_32_0;
			float4 ifLocalVar123 = 0;
			if( _ToggleMatcap == 1.0 )
				ifLocalVar123 = ifLocalVar126;
			else
				ifLocalVar123 = temp_output_86_0;
			float4 temp_cast_0 = 0;
			float4 temp_cast_1 = 1;
			float4 clampResult34 = clamp( ifLocalVar123 , temp_cast_0 , temp_cast_1 );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float fresnelNdotV4 = dot( newWorldNormal143, ase_worldViewDir );
			float fresnelNode4 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV4, 5.0 ) );
			float4 temp_cast_2 = (( fresnelNode4 * _Refaction )).xxxx;
			float4 screenColor5 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ase_grabScreenPosNorm - temp_cast_2 ).xy);
			float4 lerpResult6 = lerp( clampResult34 , screenColor5 , _Transparency);
			o.Albedo = lerpResult6.rgb;
			float4 lerpResult147 = lerp( ( tex2D( _EmissionMap, uv_TexCoord78 ) * _EmissionColor ) , screenColor5 , _Transparency);
			o.Emission = lerpResult147.rgb;
			float4 tex2DNode103 = tex2D( _MetallicGlossMap, uv_TexCoord78 );
			o.Metallic = ( _Metaliic * tex2DNode103 ).r;
			o.Smoothness = ( _Glossiness * tex2DNode103.a );
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
Version=18100
-1932;529.2;1955;879;-330.0188;605.5447;1.327757;True;False
Node;AmplifyShaderEditor.Vector4Node;75;889.1856,-151.9514;Inherit;False;Property;_TilingandOffset;Tiling and Offset;12;0;Create;False;0;0;False;0;False;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;76;1157.186,-35.95117;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;77;1160.186,-188.9516;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;78;1345.186,-141.9514;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;98;1661.764,147.3403;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;102;1696.568,-223.0492;Inherit;False;Property;_NormalMapSlider;Normal Map Slider;9;0;Create;False;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;105;2142.156,-53.14596;Inherit;False;Constant;_Vector0;Vector 0;11;0;Create;True;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;107;2008.866,-269.0493;Inherit;True;Property;_BumpMap;Normal Map;8;2;[Normal];[SingleLineTexture];Create;False;0;0;False;0;False;-1;None;4d4615a1f7d8dc64db2bc069e8a4d8df;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;106;2106.807,-356.1552;Inherit;False;Property;_UseNormalMap;Use Normal Map;7;0;Create;False;0;0;False;1;Toggle(_);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;114;2351.38,-203.784;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;146;2550.972,282.8617;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;145;-2241.509,382.1877;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;144;-2475.635,-877.1242;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;120;1309.197,183.9106;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldNormalVector;143;-2136.149,-1187.219;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WireNode;79;848.5281,233.2954;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;141;-2027.489,-1373.782;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexturePropertyNode;25;-663.9731,-1559.148;Float;True;Property;_MatcapMap;Matcap Map;17;1;[SingleLineTexture];Create;True;0;0;False;0;False;None;1392b628c5041b34789f4c720ecc3903;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.CustomExpressionNode;140;-628.1189,-1228.459;Inherit;False;half3 worldUp = float3(0,1,0)@$half3 worldViewUp = normalize(worldUp - viewDirection * dot(viewDirection, worldUp))@$half3 worldViewRight = normalize(cross(viewDirection, worldViewUp))@$half2 matcapUV = half2(dot(worldViewRight, normalDirection), dot(worldViewUp, normalDirection)) * 0.5 + 0.5@$return matcapUV@;2;False;2;True;viewDirection;FLOAT3;0,0,0;In;;Inherit;False;True;normalDirection;FLOAT3;0,0,0;In;;Inherit;False;matcapSample;True;False;0;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;80;-742.4773,-175.1135;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-326.4957,-1056.964;Float;False;Property;_MatcapStrength;Matcap Strength;19;0;Create;True;0;0;False;0;False;1;4.27;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;81;-542.9442,-519.9568;Inherit;True;Property;_MainTex;Albedo Map;1;1;[SingleLineTexture];Create;False;0;0;False;1;Header(Main);False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;122;-267.8663,-1452.98;Inherit;False;Property;_MatcapColor;Matcap Color;18;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;160;-981.704,158.7031;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;83;-490.6112,-822.0945;Inherit;False;Property;_Color;Albedo Color;2;0;Create;False;0;0;False;0;False;1,1,1,0;0,1,0.9858155,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;27;-327.2732,-1256.247;Inherit;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;158;-233.4767,315.5267;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;87.54011,-1230.532;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-39.87102,-753.0646;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosVertexDataNode;159;-905.4768,-84.47334;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;154;-41.47675,507.5267;Inherit;False;Property;_DistortSpeed;Distort Speed;22;0;Create;False;0;0;False;0;False;1;0.067;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;155;182.5232,299.5267;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;368.2428,-1376.55;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;372.2428,-1190.55;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;4;-1746.57,-758.19;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-1746.57,-470.19;Float;False;Property;_Refaction;Refaction;14;0;Create;True;0;0;False;0;False;1;0.81;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;125;306.5435,-1655.645;Inherit;False;Property;_MatcapMode;Matcap Mode;20;0;Create;True;0;0;False;1;Toggle(_);False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;121;1517.065,-338.1082;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ConditionalIfNode;126;786.3724,-1368.982;Inherit;True;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-1410.57,-630.1899;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;124;816.329,-1556.74;Inherit;False;Property;_ToggleMatcap;Toggle Matcap;16;0;Create;True;0;0;False;2;Toggle(_);Header(Matcap);False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;14;-1730.57,-1031.195;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;84;640.205,-421.3118;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;152;1126.524,507.5267;Inherit;False;Property;_DistortScale;Distort Scale;23;0;Create;False;0;0;False;0;False;6.411765;10;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;153;374.5234,283.5266;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;151;1526.524,203.5266;Inherit;True;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;36;1172.474,-1174.837;Float;False;Constant;_Int0;Int 0;6;0;Create;True;0;0;False;0;False;0;0;0;1;INT;0
Node;AmplifyShaderEditor.ColorNode;89;797.4284,-603.9484;Inherit;False;Property;_EmissionColor;Emission Color;11;1;[HDR];Create;False;0;0;False;0;False;0,0,0,0;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-233.8074,-878.4444;Float;False;Property;_Transparency;Transparency;13;0;Create;True;0;0;False;1;Header(Blending);False;0;0.197;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;150;1462.524,523.5267;Inherit;False;Property;_DistortStrength;Distort Strength;21;0;Create;False;0;0;False;1;Header(Vertex Distort);False;1;0.591;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;92;712.5864,-804.9393;Inherit;True;Property;_EmissionMap;Emission Map;10;1;[SingleLineTexture];Create;False;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;37;1176.221,-1095.018;Float;False;Constant;_Int1;Int 1;6;0;Create;True;0;0;False;0;False;1;0;0;1;INT;0
Node;AmplifyShaderEditor.ConditionalIfNode;123;1060.158,-1397.077;Inherit;True;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;71;-1170.57,-902.19;Inherit;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;149;1798.524,331.5267;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;148;1191.77,-870.0687;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;34;1665.58,-1182.445;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;1108.801,-734.0601;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;109;1745.708,-460.0323;Inherit;False;Property;_Glossiness;Smoothness Slider;6;0;Create;False;0;0;False;0;False;0;0.989;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;5;-713.9268,-976.1901;Float;False;Global;_GrabScreen0;Grab Screen 0;1;0;Create;True;0;0;False;0;False;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;103;1729.341,-660.5717;Inherit;True;Property;_MetallicGlossMap;Metallic Map;4;1;[SingleLineTexture];Create;False;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;111;1730.628,-746.2024;Inherit;False;Property;_Metaliic;Metallic Slider;5;0;Create;False;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;157;1943.739,495.2405;Inherit;False;Property;_DistortDirection;Distort Direction;24;0;Create;False;0;0;False;0;False;0,0,0;0,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;6;1891.311,-1039.825;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-2485.741,2190.45;Inherit;False;Property;_ThanksforusingmyShader;Thanks for using my Shader!;0;0;Create;False;0;0;True;5;Header(Shader by tsuna vr);Header(Discord bDWEYUw);Header(Visit for commissions and free stuff);Space(25);Toggle(_);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;156;2151.739,397.2406;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;2131.764,-559.6255;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;147;1436.553,-849.7413;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;127;2560.754,-993.0089;Inherit;False;Property;_Clip;Clip;15;1;[HideInInspector];Create;True;0;0;True;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;118;2608.698,-318.4233;Inherit;False;Property;_CullMode;Cull Mode ( 0 = None, 1 = Front, 2 = Back);25;0;Create;False;0;0;True;1;Header(Culling);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;2132.979,-717.0337;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2585.986,-809.9627;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Tsuna/Slime FX;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;3;-1;-1;-1;0;False;0;0;True;118;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;76;0;75;3
WireConnection;76;1;75;4
WireConnection;77;0;75;1
WireConnection;77;1;75;2
WireConnection;78;0;77;0
WireConnection;78;1;76;0
WireConnection;98;0;78;0
WireConnection;107;1;98;0
WireConnection;107;5;102;0
WireConnection;114;0;106;0
WireConnection;114;2;105;0
WireConnection;114;3;107;0
WireConnection;114;4;105;0
WireConnection;146;0;114;0
WireConnection;145;0;146;0
WireConnection;144;0;145;0
WireConnection;120;0;78;0
WireConnection;143;0;144;0
WireConnection;79;0;120;0
WireConnection;140;0;141;0
WireConnection;140;1;143;0
WireConnection;80;0;79;0
WireConnection;81;1;80;0
WireConnection;27;0;25;0
WireConnection;27;1;140;0
WireConnection;158;0;160;0
WireConnection;158;1;160;0
WireConnection;158;2;160;0
WireConnection;30;0;27;0
WireConnection;30;1;29;0
WireConnection;30;2;122;0
WireConnection;86;0;83;0
WireConnection;86;1;81;0
WireConnection;155;0;159;0
WireConnection;155;1;158;0
WireConnection;31;0;30;0
WireConnection;31;1;86;0
WireConnection;32;0;30;0
WireConnection;32;1;86;0
WireConnection;4;0;143;0
WireConnection;4;4;141;0
WireConnection;121;0;78;0
WireConnection;126;0;125;0
WireConnection;126;2;32;0
WireConnection;126;3;31;0
WireConnection;126;4;32;0
WireConnection;73;0;4;0
WireConnection;73;1;72;0
WireConnection;84;0;121;0
WireConnection;153;0;155;0
WireConnection;153;1;154;0
WireConnection;151;0;153;0
WireConnection;151;1;152;0
WireConnection;92;1;84;0
WireConnection;123;0;124;0
WireConnection;123;2;86;0
WireConnection;123;3;126;0
WireConnection;123;4;86;0
WireConnection;71;0;14;0
WireConnection;71;1;73;0
WireConnection;149;0;151;0
WireConnection;149;1;150;0
WireConnection;148;0;7;0
WireConnection;34;0;123;0
WireConnection;34;1;36;0
WireConnection;34;2;37;0
WireConnection;95;0;92;0
WireConnection;95;1;89;0
WireConnection;5;0;71;0
WireConnection;103;1;78;0
WireConnection;6;0;34;0
WireConnection;6;1;5;0
WireConnection;6;2;7;0
WireConnection;156;0;149;0
WireConnection;156;1;157;0
WireConnection;113;0;109;0
WireConnection;113;1;103;4
WireConnection;147;0;95;0
WireConnection;147;1;5;0
WireConnection;147;2;148;0
WireConnection;112;0;111;0
WireConnection;112;1;103;0
WireConnection;0;0;6;0
WireConnection;0;1;114;0
WireConnection;0;2;147;0
WireConnection;0;3;112;0
WireConnection;0;4;113;0
WireConnection;0;11;156;0
ASEEND*/
//CHKSM=34AD0114CD6491E6D95E37FA3176B4F1F000685A