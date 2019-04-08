package LayaAir3D_Scene3D {
	import common.CameraMoveScript;
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.PBRStandardMaterial;
	import laya.d3.core.material.SkyBoxMaterial;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.math.Vector3;
	import laya.d3.resource.models.PrimitiveMesh;
	import laya.d3.resource.models.SkyBox;
	import laya.d3.resource.models.SkyRenderer;
	import laya.display.Stage;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.resource.Texture2D;
	import laya.d3.resource.models.Mesh;
	
	public class EnvironmentalReflection {
		
		private var rotation:Vector3 = new Vector3(0, 0.01, 0);
		private var sprite3D:Sprite3D;
		private var scene:Scene3D = null;
		private var teapot:MeshSprite3D = null;
		
		public function EnvironmentalReflection() {
			
			Laya3D.init(0, 0);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			//创建场景
			var scene:Scene3D = new Scene3D();
			Laya.stage.addChild(scene);
			//设置场景的反射模式(全局有效)
			scene.reflectionMode = Scene3D.REFLECTIONMODE_CUSTOM;
			scene.reflectionIntensity = 1.0;
			//初始化照相机
			var camera:Camera = scene.addChild(new Camera(0, 0.1, 100)) as Camera;
			camera.transform.translate(new Vector3(0, 2, 3));
			camera.transform.rotate(new Vector3(-15, 0, 0), true, false);
			//为相机添加视角控制组件(脚本)
			camera.addComponent(CameraMoveScript);
			//设置相机的清除标识为天空盒
			camera.clearFlag = BaseCamera.CLEARFLAG_SKY;
			
			//天空盒
			BaseMaterial.load("res/threeDimen/skyBox/DawnDusk/SkyBox.lmat", Handler.create(this, function(mat:SkyBoxMaterial):void {
				//获取相机的天空盒渲染体
				var skyRenderer:SkyRenderer = camera.skyRenderer;
				//设置天空盒mesh
				skyRenderer.mesh = SkyBox.instance;
				//设置天空盒材质
				skyRenderer.material = mat;
				//设置场景的反射贴图
				scene.customReflection = mat.textureCube;
				//设置曝光强度
				mat.exposure = 0.6 + 1;
			}));
			//创建平行光
			var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
			directionLight.color = new Vector3(0.6, 0.6, 0.6);
		
			//加载Mesh
			Mesh.load("res/threeDimen/staticModel/teapot/teapot-Teapot001.lm", Handler.create(this, function(mesh:Mesh):void {
				teapot = scene.addChild(new MeshSprite3D(mesh)) as MeshSprite3D;
				teapot.transform.position = new Vector3(0, 1.75, 2);
				teapot.transform.rotate(new Vector3(-90, 0, 0), false, false);
			}));
			
			//实例PBR材质
			var pbrMat:PBRStandardMaterial = new PBRStandardMaterial();
			//开启该材质的反射
			pbrMat.enableReflection = true;
			//设置材质的金属度，尽量高点，反射效果更明显
			pbrMat.metallic = 1;
			
			//加载纹理
			Texture2D.load("res/threeDimen/pbr/jinshu.jpg", Handler.create(this, function(tex:Texture2D):void {
				//pbrMat.albedoTexture = tex;
				teapot.meshRenderer.material = pbrMat;
			}));
		}
	}
}