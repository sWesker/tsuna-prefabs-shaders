// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tsuna/Vertex Color Splat FX"
{
	Properties
	{
		_Tiling("Tiling", Vector) = (1,1,0,0)
		_Angle("Angle", Range( 0 , 1)) = 0
		_NormalStrength("Normal Strength", Range( -2 , 2)) = 1
		_Glossiness("Smoothness", Range( 0 , 1)) = 0
		_Metallic("Metallic", Range( 0 , 1)) = 0
		[SingleLineTexture]_MainTex("MainTex", 2D) = "white" {}
		[Normal][SingleLineTexture]_BumpMap("BumpMap", 2D) = "bump" {}
		_RBalance("R Balance", Range( 0 , 1)) = 1
		[SingleLineTexture]_R("R", 2D) = "white" {}
		[Normal][SingleLineTexture]_RNormal("R Normal", 2D) = "bump" {}
		_GBalance("G Balance", Range( 0 , 1)) = 1
		[SingleLineTexture]_G("G", 2D) = "white" {}
		[Normal][SingleLineTexture]_GNormal("G Normal", 2D) = "bump" {}
		_BBalance("B Balance", Range( 0 , 1)) = 1
		[SingleLineTexture]_B("B", 2D) = "white" {}
		[Normal][SingleLineTexture]_BNormal("B Normal", 2D) = "bump" {}
		_ABalance("A Balance", Range( 0 , 1)) = 1
		[SingleLineTexture]_A("A", 2D) = "white" {}
		[Normal][SingleLineTexture]_ANormal("A Normal", 2D) = "bump" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _BumpMap;
		uniform float2 _Tiling;
		uniform float _Angle;
		uniform sampler2D _RNormal;
		uniform float _RBalance;
		uniform sampler2D _GNormal;
		uniform float _GBalance;
		uniform sampler2D _BNormal;
		uniform float _BBalance;
		uniform sampler2D _ANormal;
		uniform float _ABalance;
		uniform float _NormalStrength;
		uniform sampler2D _MainTex;
		uniform sampler2D _R;
		uniform sampler2D _G;
		uniform sampler2D _B;
		uniform sampler2D _A;
		uniform float _Metallic;
		uniform float _Glossiness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord36 = i.uv_texcoord * _Tiling;
			float cos33 = cos( _Angle );
			float sin33 = sin( _Angle );
			float2 rotator33 = mul( uv_TexCoord36 - float2( 0,0 ) , float2x2( cos33 , -sin33 , sin33 , cos33 )) + float2( 0,0 );
			float temp_output_32_0 = ( i.vertexColor.r * _RBalance );
			float3 lerpResult13 = lerp( UnpackNormal( tex2D( _BumpMap, rotator33 ) ) , UnpackNormal( tex2D( _RNormal, rotator33 ) ) , temp_output_32_0);
			float temp_output_25_0 = ( i.vertexColor.g * _GBalance );
			float3 lerpResult17 = lerp( lerpResult13 , UnpackNormal( tex2D( _GNormal, rotator33 ) ) , temp_output_25_0);
			float temp_output_27_0 = ( i.vertexColor.b * _BBalance );
			float3 lerpResult18 = lerp( lerpResult17 , UnpackNormal( tex2D( _BNormal, rotator33 ) ) , temp_output_27_0);
			float temp_output_29_0 = ( i.vertexColor.a * _ABalance );
			float3 lerpResult19 = lerp( lerpResult18 , UnpackNormal( tex2D( _ANormal, rotator33 ) ) , temp_output_29_0);
			float3 break44 = lerpResult19;
			float2 appendResult42 = (float2(break44.x , break44.y));
			float3 appendResult45 = (float3(( appendResult42 * _NormalStrength ) , break44.z));
			o.Normal = appendResult45;
			float4 lerpResult6 = lerp( tex2D( _MainTex, rotator33 ) , tex2D( _R, rotator33 ) , temp_output_32_0);
			float4 lerpResult9 = lerp( lerpResult6 , tex2D( _G, rotator33 ) , temp_output_25_0);
			float4 lerpResult10 = lerp( lerpResult9 , tex2D( _B, rotator33 ) , temp_output_27_0);
			float4 lerpResult11 = lerp( lerpResult10 , tex2D( _A, rotator33 ) , temp_output_29_0);
			o.Albedo = lerpResult11.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17900
0;20;3072;1646;2228.64;703.209;1;True;False
Node;AmplifyShaderEditor.Vector2Node;37;-1858.61,-488.938;Inherit;False;Property;_Tiling;Tiling;0;0;Create;True;0;0;False;0;1,1;50,50;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;-1594.691,-507.9637;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;34;-1638.691,-316.9637;Inherit;False;Property;_Angle;Angle;1;0;Create;True;0;0;False;0;0;0.75;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;7;-628.9894,-292.2523;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotatorNode;33;-1204.045,-390.9226;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-682.9246,-114.5333;Inherit;False;Property;_RBalance;R Balance;7;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;15;-745.2407,-32.76833;Inherit;True;Property;_RNormal;R Normal;9;2;[Normal];[SingleLineTexture];Create;True;0;0;False;0;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;14;-727.9406,196.885;Inherit;True;Property;_BumpMap;BumpMap;6;2;[Normal];[SingleLineTexture];Create;True;0;0;False;0;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-311.9246,-280.5333;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-384,-112;Inherit;False;Property;_GBalance;G Balance;10;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-38,-291;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-72.42456,-111.0333;Inherit;False;Property;_BBalance;B Balance;13;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;13;-120.0405,-23.31494;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;16;-351.6404,201.5848;Inherit;True;Property;_GNormal;G Normal;12;2;[Normal];[SingleLineTexture];Create;True;0;0;False;0;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;30;215.5754,-110.5333;Inherit;False;Property;_ABalance;A Balance;16;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;27.55337,211.2043;Inherit;True;Property;_BNormal;B Normal;15;2;[Normal];[SingleLineTexture];Create;True;0;0;False;0;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;17;119.9869,-12.29107;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;168.5755,-284.0333;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;463.5755,-282.5333;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;21;393.0382,209.8552;Inherit;True;Property;_ANormal;A Normal;18;2;[Normal];[SingleLineTexture];Create;True;0;0;False;0;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;18;390.3242,-17.91959;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;19;648.071,-17.82916;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;8;-504,-512.5;Inherit;True;Property;_MainTex;MainTex;5;1;[SingleLineTexture];Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-500,-730.5;Inherit;True;Property;_R;R;8;1;[SingleLineTexture];Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;44;861.1707,10.651;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.LerpOp;6;-139,-440.5;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;3;-183,-736.5;Inherit;True;Property;_G;G;11;1;[SingleLineTexture];Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;42;1129.084,3.562256;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;43;837.3729,152.2914;Inherit;False;Property;_NormalStrength;Normal Strength;2;0;Create;True;0;0;False;0;1;2;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;9;144.2275,-445.1761;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;4;146.9939,-721.9806;Inherit;True;Property;_B;B;14;1;[SingleLineTexture];Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;1303.615,-0.8562012;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;5;497.8787,-722.0297;Inherit;True;Property;_A;A;17;1;[SingleLineTexture];Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;10;472.7647,-445.2046;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;11;797.6115,-442.5142;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;23;669.2156,-186.1473;Inherit;False;Property;_Glossiness;Smoothness;3;0;Create;False;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;45;1482.171,25.651;Inherit;False;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;22;672.2156,-277.1473;Inherit;False;Property;_Metallic;Metallic;4;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1776.391,-446.5115;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Tsuna/Vertex Color Splat FX;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;36;0;37;0
WireConnection;33;0;36;0
WireConnection;33;2;34;0
WireConnection;15;1;33;0
WireConnection;14;1;33;0
WireConnection;32;0;7;1
WireConnection;32;1;31;0
WireConnection;25;0;7;2
WireConnection;25;1;26;0
WireConnection;13;0;14;0
WireConnection;13;1;15;0
WireConnection;13;2;32;0
WireConnection;16;1;33;0
WireConnection;20;1;33;0
WireConnection;17;0;13;0
WireConnection;17;1;16;0
WireConnection;17;2;25;0
WireConnection;27;0;7;3
WireConnection;27;1;28;0
WireConnection;29;0;7;4
WireConnection;29;1;30;0
WireConnection;21;1;33;0
WireConnection;18;0;17;0
WireConnection;18;1;20;0
WireConnection;18;2;27;0
WireConnection;19;0;18;0
WireConnection;19;1;21;0
WireConnection;19;2;29;0
WireConnection;8;1;33;0
WireConnection;2;1;33;0
WireConnection;44;0;19;0
WireConnection;6;0;8;0
WireConnection;6;1;2;0
WireConnection;6;2;32;0
WireConnection;3;1;33;0
WireConnection;42;0;44;0
WireConnection;42;1;44;1
WireConnection;9;0;6;0
WireConnection;9;1;3;0
WireConnection;9;2;25;0
WireConnection;4;1;33;0
WireConnection;40;0;42;0
WireConnection;40;1;43;0
WireConnection;5;1;33;0
WireConnection;10;0;9;0
WireConnection;10;1;4;0
WireConnection;10;2;27;0
WireConnection;11;0;10;0
WireConnection;11;1;5;0
WireConnection;11;2;29;0
WireConnection;45;0;40;0
WireConnection;45;2;44;2
WireConnection;0;0;11;0
WireConnection;0;1;45;0
WireConnection;0;3;22;0
WireConnection;0;4;23;0
ASEEND*/
//CHKSM=130896E4793A2E6B68BC6454D80870E87432DB5D