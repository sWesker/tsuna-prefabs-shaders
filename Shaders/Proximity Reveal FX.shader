// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tsuna/Proximity Reveal FX"
{
	Properties
	{
		[Header(Shader by tsuna vr)][Header(Discord bDWEYUw)][Header(Visit for commissions and free stuff)][Space(25)][Toggle(_)]_ThanksforusingmyShader("Thanks for using my Shader!", Float) = 0
		[SingleLineTexture][Header(Main)]_MainTex("Albedo Map", 2D) = "white" {}
		_Color("Albedo Color", Color) = (1,1,1,1)
		[SingleLineTexture]_MetallicGlossMap("Metallic Map", 2D) = "white" {}
		_Metaliic("Metallic Slider", Range( 0 , 1)) = 0
		_Glossiness("Smoothness Slider", Range( 0 , 1)) = 0
		[Toggle(_)]_UseNormalMap("Use Normal Map", Float) = 0
		[Normal][SingleLineTexture]_BumpMap("Normal Map", 2D) = "bump" {}
		_NormalMapSlider("Normal Map Slider", Range( 0 , 1)) = 0
		[SingleLineTexture]_EmissionMap("Emission Map", 2D) = "black" {}
		[HDR]_EmissionColor("Emission Color", Color) = (1,1,1,1)
		_TilingandOffset("Tiling and Offset", Vector) = (0,0,0,0)
		[Header(Distance)]_Minimum("Minimum", Float) = 0
		_Maximum("Maximum", Float) = 5
		[Header(Culling)]_BackfaceDimming("Backface Dimming", Range( 0 , 1)) = 0
		_Clip("Clip", Range( 0 , 1)) = 0.5
		_Cull("Cull Mode ( 0 = None, 1 = Front, 2 = Back)", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull [_Cull]
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			half ASEVFace : VFACE;
			float3 worldPos;
		};

		uniform float _ThanksforusingmyShader;
		uniform float _Clip;
		uniform float _Cull;
		uniform float _UseNormalMap;
		uniform float _NormalMapSlider;
		uniform sampler2D _BumpMap;
		uniform float4 _TilingandOffset;
		uniform float4 _Color;
		uniform sampler2D _MainTex;
		uniform float _BackfaceDimming;
		uniform float4 _EmissionColor;
		uniform sampler2D _EmissionMap;
		uniform float _Metaliic;
		uniform sampler2D _MetallicGlossMap;
		uniform float _Glossiness;
		uniform float _Minimum;
		uniform float _Maximum;


		float GetDistanceData( float3 CamPos , float3 VertWorldPos , float MinRange , float MaxRange )
		{
			return (0.0 + ( clamp( distance( CamPos.xyz , VertWorldPos ) , MinRange , MaxRange ) - MaxRange) * (1.0 - 0.0) / (MinRange - MaxRange));
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 _Vector2 = float3(0,0,1);
			float2 appendResult26 = (float2(_TilingandOffset.x , _TilingandOffset.y));
			float2 appendResult25 = (float2(_TilingandOffset.z , _TilingandOffset.w));
			float2 uv_TexCoord24 = i.uv_texcoord * appendResult26 + appendResult25;
			float3 ifLocalVar16 = 0;
			if( _UseNormalMap == 1.0 )
				ifLocalVar16 = UnpackScaleNormal( tex2D( _BumpMap, uv_TexCoord24 ), _NormalMapSlider );
			else
				ifLocalVar16 = _Vector2;
			o.Normal = ifLocalVar16;
			o.Albedo = ( ( _Color * tex2D( _MainTex, uv_TexCoord24 ) ) * (_BackfaceDimming + (i.ASEVFace - -1.0) * (1.0 - _BackfaceDimming) / (1.0 - -1.0)) ).rgb;
			o.Emission = ( _EmissionColor * tex2D( _EmissionMap, uv_TexCoord24 ) ).rgb;
			float4 tex2DNode11 = tex2D( _MetallicGlossMap, uv_TexCoord24 );
			o.Metallic = ( _Metaliic * tex2DNode11 ).r;
			o.Smoothness = ( _Glossiness * tex2DNode11.a );
			o.Alpha = 1;
			float3 CamPos34 = _WorldSpaceCameraPos;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 objToWorld35 = mul( unity_ObjectToWorld, float4( ase_vertex3Pos, 1 ) ).xyz;
			float3 VertWorldPos34 = objToWorld35;
			float MinRange34 = _Minimum;
			float MaxRange34 = _Maximum;
			float localGetDistanceData34 = GetDistanceData( CamPos34 , VertWorldPos34 , MinRange34 , MaxRange34 );
			clip( localGetDistanceData34 - _Clip );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
-1853;498.2;1788;978;564.3793;738.2964;1;True;False
Node;AmplifyShaderEditor.Vector4Node;27;-3522.66,532.6083;Inherit;False;Property;_TilingandOffset;Tiling and Offset;11;0;Create;False;0;0;False;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;25;-3254.66,646.6082;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;26;-3251.66,493.6084;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;24;-3066.66,540.6083;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;22;-2124.61,-479.4384;Inherit;False;Property;_Color;Albedo Color;2;0;Create;False;0;0;False;0;False;1,1,1,1;1,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-683.8557,718.3372;Inherit;False;Property;_NormalMapSlider;Normal Map Slider;8;0;Create;False;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1003.825,-611.9528;Inherit;False;Property;_BackfaceDimming;Backface Dimming;14;0;Create;True;0;0;False;1;Header(Culling);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;21;-2121.877,-248.906;Inherit;True;Property;_MainTex;Albedo Map;1;1;[SingleLineTexture];Create;False;0;0;False;1;Header(Main);False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;8;-467.4387,656.7778;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FaceVariableNode;30;-827.8246,-723.9528;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;2;-610.9999,-57.60001;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-1412.112,-321.0255;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;19;-1718.017,0.01029968;Inherit;False;Property;_EmissionColor;Emission Color;10;1;[HDR];Create;True;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-218.2042,581.9218;Inherit;False;Property;_UseNormalMap;Use Normal Map;6;0;Create;False;0;0;False;1;Toggle(_);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;13;-194.9749,874.9312;Inherit;False;Constant;_Vector2;Vector 2;11;0;Create;True;0;0;False;0;False;0,0,1;0,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;35;-356.7435,-95.88477;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;14;-320.2637,669.028;Inherit;True;Property;_BumpMap;Normal Map;7;2;[Normal];[SingleLineTexture];Create;False;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldSpaceCameraPos;1;-664,-218;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;10;-295.7606,105.9718;Inherit;False;Property;_Metaliic;Metallic Slider;4;0;Create;False;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;18;-1781.076,345.8422;Inherit;True;Property;_EmissionMap;Emission Map;9;1;[SingleLineTexture];Create;True;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;36;-85.74353,-25.88452;Inherit;False;Property;_Maximum;Maximum;13;0;Create;True;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;-315.0734,198.2015;Inherit;True;Property;_MetallicGlossMap;Metallic Map;3;1;[SingleLineTexture];Create;False;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;37;-85.74353,-111.8845;Inherit;False;Property;_Minimum;Minimum;12;0;Create;True;0;0;False;1;Header(Distance);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-263.2088,401.912;Inherit;False;Property;_Glossiness;Smoothness Slider;5;0;Create;False;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;32;-651.8246,-675.9528;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;16;22.25023,734.2927;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;115.8471,329.319;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;124.0632,144.9107;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomExpressionNode;34;162.5109,-219.2974;Inherit;False;return (0.0 + ( clamp( distance( CamPos.xyz , VertWorldPos ) , MinRange , MaxRange ) - MaxRange) * (1.0 - 0.0) / (MinRange - MaxRange))@;1;False;4;True;CamPos;FLOAT3;0,0,0;In;;Inherit;False;True;VertWorldPos;FLOAT3;0,0,0;In;;Inherit;False;True;MinRange;FLOAT;0;In;;Inherit;False;True;MaxRange;FLOAT;1;In;;Inherit;False;GetDistanceData;False;True;0;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-240.9247,-324.6529;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;6;563.0843,-281.6015;Inherit;False;Property;_Clip;Clip;15;0;Create;False;0;0;True;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1403.524,115.8641;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;29;410.4582,-804.7923;Inherit;False;Property;_ThanksforusingmyShader;Thanks for using my Shader!;0;0;Create;True;0;0;True;5;Header(Shader by tsuna vr);Header(Discord bDWEYUw);Header(Visit for commissions and free stuff);Space(25);Toggle(_);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;556.0433,-400.0232;Inherit;False;Property;_Cull;Cull Mode ( 0 = None, 1 = Front, 2 = Back);16;0;Create;False;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;568.9999,-175.1;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Tsuna/Proximity Reveal FX;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;5;-1;0;True;6;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;27;3
WireConnection;25;1;27;4
WireConnection;26;0;27;1
WireConnection;26;1;27;2
WireConnection;24;0;26;0
WireConnection;24;1;25;0
WireConnection;21;1;24;0
WireConnection;8;0;24;0
WireConnection;23;0;22;0
WireConnection;23;1;21;0
WireConnection;35;0;2;0
WireConnection;14;1;8;0
WireConnection;14;5;7;0
WireConnection;18;1;24;0
WireConnection;11;1;24;0
WireConnection;32;0;30;0
WireConnection;32;3;31;0
WireConnection;16;0;12;0
WireConnection;16;2;13;0
WireConnection;16;3;14;0
WireConnection;16;4;13;0
WireConnection;15;0;9;0
WireConnection;15;1;11;4
WireConnection;17;0;10;0
WireConnection;17;1;11;0
WireConnection;34;0;1;0
WireConnection;34;1;35;0
WireConnection;34;2;37;0
WireConnection;34;3;36;0
WireConnection;33;0;23;0
WireConnection;33;1;32;0
WireConnection;20;0;19;0
WireConnection;20;1;18;0
WireConnection;0;0;33;0
WireConnection;0;1;16;0
WireConnection;0;2;20;0
WireConnection;0;3;17;0
WireConnection;0;4;15;0
WireConnection;0;10;34;0
ASEEND*/
//CHKSM=74F2124ABB38054139E17D153DCBC0383A9A4003