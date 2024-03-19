(()=>{var t={886:()=>{L.WebGLHeatMap=L.Renderer.extend({version:"0.2.7",options:{size:3e4,units:"m",opacity:1,gradientTexture:!1,alphaRange:1,padding:0},_initContainer:function(){var t=this._container=L.DomUtil.create("canvas","leaflet-zoom-animated"),e=this.options;t.id="webgl-leaflet-"+L.Util.stamp(this),t.style.opacity=e.opacity,t.style.position="absolute";try{this.gl=window.createWebGLHeatmap({canvas:t,gradientTexture:e.gradientTexture,alphaRange:[0,e.alphaRange]})}catch(t){console.error(t),this.gl={clear:function(){},update:function(){},multiply:function(){},addPoint:function(){},display:function(){},adjustSize:function(){}}}this._container=t},onAdd:function(){this.size=this.options.size,L.Renderer.prototype.onAdd.call(this),this.resize()},_destroyContainer:function(){delete this.gl,L.DomUtil.remove(this._container),L.DomEvent.off(this._container),delete this._container},getEvents:function(){var t=L.Renderer.prototype.getEvents.call(this);return L.Util.extend(t,{resize:this.resize,move:L.Util.throttle(this._update,49,this)}),t},resize:function(){var t=this._container,e=this._map.getSize();t.width=e.x,t.height=e.y,this.gl.adjustSize(),this.draw()},reposition:function(){var t=this._map._getMapPanePos().multiplyBy(-1);L.DomUtil.setPosition(this._container,t)},_update:function(){L.Renderer.prototype._update.call(this),this.draw()},draw:function(){var t=this._map,e=this.gl,i=this.data,r=i.length,n=Math.floor,o=this["_scale"+this.options.units].bind(this),h=this._multiply;if(t){if(e.clear(),this.reposition(),r){for(var s=0;s<r;s++){var a=i[s],l=L.latLng(a),u=t.latLngToContainerPoint(l);e.addPoint(n(u.x),n(u.y),o(l),a[2])}e.update(),h&&(e.multiply(h),e.update())}e.display()}},_scalem:function(t){var e=this._map,i=this.size/40075017*360/Math.cos(Math.PI/180*t.lat),r=new L.LatLng(t.lat,t.lng-i),n=e.latLngToLayerPoint(t),o=e.latLngToLayerPoint(r);return Math.max(Math.round(n.x-o.x),1)},_scalepx:function(){return this.size},data:[],addDataPoint:function(t,e,i){this.data.push([t,e,i/100])},setData:function(t){this.data=t,this._multiply=null,this.draw()},clear:function(){this.setData([])},multiply:function(t){this._multiply=t,this.draw()}}),L.webGLHeatmap=function(t){return new L.WebGLHeatMap(t)}},839:function(){(function(){var t,e,i,r,n,o,h,s,a,l,u,f,g,c=[].indexOf||function(t){for(var e=0,i=this.length;e<i;e++)if(e in this&&this[e]===t)return e;return-1};s=function(){var t,e,i,r,n,o,h,s,a,l,u,f,g,d;if((n=function(){var t,e,i;return(t=document.createElement("canvas")).width=2,t.height=2,(i=(e=t.getContext("2d")).getImageData(0,0,2,2)).data.set(new Uint8ClampedArray([0,0,0,0,255,255,255,255,0,0,0,0,255,255,255,255])),e.putImageData(i,0,0),t})(),e=function(t,e){var i,r,o,h,s,a,l,u,f,g,c,d,p,_;if(a=t.createProgram(),p=t.createShader(t.VERTEX_SHADER),t.attachShader(a,p),t.shaderSource(p,"attribute vec2 position;\nvoid main(){\n    gl_Position = vec4(position, 0.0, 1.0);\n}"),t.compileShader(p),!t.getShaderParameter(p,t.COMPILE_STATUS))throw t.getShaderInfoLog(p);if(o=t.createShader(t.FRAGMENT_SHADER),t.attachShader(a,o),t.shaderSource(o,"uniform sampler2D source;\nvoid main(){\n    gl_FragColor = texture2D(source, vec2(1.0, 1.0));\n}"),t.compileShader(o),!t.getShaderParameter(o,t.COMPILE_STATUS))throw t.getShaderInfoLog(o);if(t.linkProgram(a),!t.getProgramParameter(a,t.LINK_STATUS))throw t.getProgramInfoLog(a);return t.useProgram(a),r=function(){return t.deleteShader(o),t.deleteShader(p),t.deleteProgram(a),t.deleteBuffer(i),t.deleteTexture(f),t.deleteTexture(d),t.deleteFramebuffer(h),t.bindBuffer(t.ARRAY_BUFFER,null),t.useProgram(null),t.bindTexture(t.TEXTURE_2D,null),t.bindFramebuffer(t.FRAMEBUFFER,null)},d=t.createTexture(),t.bindTexture(t.TEXTURE_2D,d),t.texImage2D(t.TEXTURE_2D,0,t.RGBA,2,2,0,t.RGBA,t.UNSIGNED_BYTE,null),t.texParameteri(t.TEXTURE_2D,t.TEXTURE_MAG_FILTER,t.LINEAR),t.texParameteri(t.TEXTURE_2D,t.TEXTURE_MIN_FILTER,t.LINEAR),h=t.createFramebuffer(),t.bindFramebuffer(t.FRAMEBUFFER,h),t.framebufferTexture2D(t.FRAMEBUFFER,t.COLOR_ATTACHMENT0,t.TEXTURE_2D,d,0),g=n(),f=t.createTexture(),t.bindTexture(t.TEXTURE_2D,f),t.texImage2D(t.TEXTURE_2D,0,t.RGBA,t.RGBA,e,g),t.texParameteri(t.TEXTURE_2D,t.TEXTURE_MAG_FILTER,t.LINEAR),t.texParameteri(t.TEXTURE_2D,t.TEXTURE_MIN_FILTER,t.LINEAR),_=new Float32Array([1,1,-1,1,-1,-1,1,1,-1,-1,1,-1]),i=t.createBuffer(),t.bindBuffer(t.ARRAY_BUFFER,i),t.bufferData(t.ARRAY_BUFFER,_,t.STATIC_DRAW),s=t.getAttribLocation(a,"position"),c=t.getUniformLocation(a,"source"),t.enableVertexAttribArray(s),t.vertexAttribPointer(s,2,t.FLOAT,!1,0,0),t.uniform1i(c,0),t.drawArrays(t.TRIANGLES,0,6),l=new Uint8Array(16),t.readPixels(0,0,2,2,t.RGBA,t.UNSIGNED_BYTE,l),u=Math.abs(l[0]-127)<10,r(),u},r=function(t,e){var i;return i=t.createTexture(),t.bindTexture(t.TEXTURE_2D,i),t.texImage2D(t.TEXTURE_2D,0,t.RGBA,2,2,0,t.RGBA,e,null),0===t.getError()?(t.deleteTexture(i),!0):(t.deleteTexture(i),!1)},t=function(t,e){var i,r,n;return n=t.createTexture(),t.bindTexture(t.TEXTURE_2D,n),t.texImage2D(t.TEXTURE_2D,0,t.RGBA,2,2,0,t.RGBA,e,null),r=t.createFramebuffer(),t.bindFramebuffer(t.FRAMEBUFFER,r),t.framebufferTexture2D(t.FRAMEBUFFER,t.COLOR_ATTACHMENT0,t.TEXTURE_2D,n,0),i=t.checkFramebufferStatus(t.FRAMEBUFFER),t.deleteTexture(n),t.deleteFramebuffer(r),t.bindTexture(t.TEXTURE_2D,null),t.bindFramebuffer(t.FRAMEBUFFER,null),i===t.FRAMEBUFFER_COMPLETE},a=[],l={},u=[],i=function(){var i,n,o,h,s;i=document.createElement("canvas"),n=null;try{null===(n=i.getContext("experimental-webgl"))&&(n=i.getContext("webgl"))}catch(t){}if(null!=n&&(null===n.getExtension("OES_texture_float")?r(n,n.FLOAT)?(s=!0,a.push("OES_texture_float"),l.OES_texture_float={shim:!0}):(s=!1,u.push("OES_texture_float")):r(n,n.FLOAT)?(s=!0,a.push("OES_texture_float")):(s=!1,u.push("OES_texture_float")),s&&(null===n.getExtension("WEBGL_color_buffer_float")?t(n,n.FLOAT)?(a.push("WEBGL_color_buffer_float"),l.WEBGL_color_buffer_float={shim:!0,RGBA32F_EXT:34836,RGB32F_EXT:34837,FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE_EXT:33297,UNSIGNED_NORMALIZED_EXT:35863}):u.push("WEBGL_color_buffer_float"):t(n,n.FLOAT)?a.push("WEBGL_color_buffer_float"):u.push("WEBGL_color_buffer_float"),null===n.getExtension("OES_texture_float_linear")?e(n,n.FLOAT)?(a.push("OES_texture_float_linear"),l.OES_texture_float_linear={shim:!0}):u.push("OES_texture_float_linear"):e(n,n.FLOAT)?a.push("OES_texture_float_linear"):u.push("OES_texture_float_linear")),null===(o=n.getExtension("OES_texture_half_float"))?r(n,36193)?(h=!0,a.push("OES_texture_half_float"),o=l.OES_texture_half_float={HALF_FLOAT_OES:36193,shim:!0}):(h=!1,u.push("OES_texture_half_float")):r(n,o.HALF_FLOAT_OES)?(h=!0,a.push("OES_texture_half_float")):(h=!1,u.push("OES_texture_half_float")),h))return null===n.getExtension("EXT_color_buffer_half_float")?t(n,o.HALF_FLOAT_OES)?(a.push("EXT_color_buffer_half_float"),l.EXT_color_buffer_half_float={shim:!0,RGBA16F_EXT:34842,RGB16F_EXT:34843,FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE_EXT:33297,UNSIGNED_NORMALIZED_EXT:35863}):u.push("EXT_color_buffer_half_float"):t(n,o.HALF_FLOAT_OES)?a.push("EXT_color_buffer_half_float"):u.push("EXT_color_buffer_half_float"),null===n.getExtension("OES_texture_half_float_linear")?e(n,o.HALF_FLOAT_OES)?(a.push("OES_texture_half_float_linear"),l.OES_texture_half_float_linear={shim:!0}):u.push("OES_texture_half_float_linear"):e(n,o.HALF_FLOAT_OES)?a.push("OES_texture_half_float_linear"):u.push("OES_texture_half_float_linear")},null!=window.WebGLRenderingContext){for(i(),f={},g=0,d=u.length;g<d;g++)s=u[g],f[s]=!0;return o=WebGLRenderingContext.prototype.getExtension,WebGLRenderingContext.prototype.getExtension=function(t){var e;return void 0===(e=l[t])?f[t]?null:o.call(this,t):e},h=WebGLRenderingContext.prototype.getSupportedExtensions,WebGLRenderingContext.prototype.getSupportedExtensions=function(){var t,e,i,r,n,o,s;for(e=[],r=0,o=(i=h.call(this)).length;r<o;r++)t=i[r],void 0===f[t]&&e.push(t);for(n=0,s=a.length;n<s;n++)t=a[n],c.call(e,t)<0&&e.push(t);return e},WebGLRenderingContext.prototype.getFloatExtension=function(t){var e,i,r,n,o,h,a,l,u,f,g,c,d,p,_,E,x,T,m,R,b,v,A,F,y,L;for(null==t.prefer&&(t.prefer=["half"]),null==t.require&&(t.require=[]),null==t.throws&&(t.throws=!0),p=this.getExtension("OES_texture_float"),h=this.getExtension("OES_texture_half_float"),c=this.getExtension("WEBGL_color_buffer_float"),n=this.getExtension("EXT_color_buffer_half_float"),d=this.getExtension("OES_texture_float_linear"),o=this.getExtension("OES_texture_half_float_linear"),g={texture:null!==p,filterable:null!==d,renderable:null!==c,score:0,precision:"single",half:!1,single:!0,type:this.FLOAT},r={texture:null!==h,filterable:null!==o,renderable:null!==n,score:0,precision:"half",half:!0,single:!1,type:null!=(F=null!=h?h.HALF_FLOAT_OES:void 0)?F:null},i=[],g.texture&&i.push(g),r.texture&&i.push(r),f=[],E=0,m=i.length;E<m;E++){for(e=i[E],_=!0,x=0,R=(y=t.require).length;x<R;x++)!1===e[s=y[x]]&&(_=!1);_&&f.push(e)}for(T=0,b=f.length;T<b;T++)for(e=f[T],a=A=0,v=(L=t.prefer).length;A<v;a=++A)u=L[a],l=Math.pow(2,t.prefer.length-a-1),e[u]&&(e.score+=l);if(f.sort((function(t,e){return t.score===e.score?0:t.score<e.score?1:t.score>e.score?-1:void 0})),0===f.length){if(t.throws)throw"No floating point texture support that is "+t.require.join(", ");return null}return{filterable:(f=f[0]).filterable,renderable:f.renderable,type:f.type,precision:f.precision}}}},null!=window.WebGLRenderingContext&&(g=["WEBKIT","MOZ","MS","O"],f=/^WEBKIT_(.*)|MOZ_(.*)|MS_(.*)|O_(.*)/,l=WebGLRenderingContext.prototype.getExtension,WebGLRenderingContext.prototype.getExtension=function(t){var e,i,r,n,o;if(null!==(i=t.match(f))&&(t=i[1]),null===(e=l.call(this,t))){for(n=0,o=g.length;n<o;n++)if(r=g[n],null!==(e=l.call(this,r+"_"+t)))return e;return null}return e},u=WebGLRenderingContext.prototype.getSupportedExtensions,WebGLRenderingContext.prototype.getSupportedExtensions=function(){var t,e,i,r,n,o;for(i=[],n=0,o=(r=u.call(this)).length;n<o;n++)null!==(e=(t=r[n]).match(f))&&(t=e[1]),c.call(i,t)<0&&i.push(t);return i}),s(),r=function(){function t(t,e){var i,r;this.gl=t,r=e.vertex,i=e.fragment,this.program=this.gl.createProgram(),this.vs=this.gl.createShader(this.gl.VERTEX_SHADER),this.fs=this.gl.createShader(this.gl.FRAGMENT_SHADER),this.gl.attachShader(this.program,this.vs),this.gl.attachShader(this.program,this.fs),this.compileShader(this.vs,r),this.compileShader(this.fs,i),this.link(),this.value_cache={},this.uniform_cache={},this.attribCache={}}return t.prototype.attribLocation=function(t){var e;return void 0===(e=this.attribCache[t])&&(e=this.attribCache[t]=this.gl.getAttribLocation(this.program,t)),e},t.prototype.compileShader=function(t,e){if(this.gl.shaderSource(t,e),this.gl.compileShader(t),!this.gl.getShaderParameter(t,this.gl.COMPILE_STATUS))throw"Shader Compile Error: "+this.gl.getShaderInfoLog(t)},t.prototype.link=function(){if(this.gl.linkProgram(this.program),!this.gl.getProgramParameter(this.program,this.gl.LINK_STATUS))throw"Shader Link Error: "+this.gl.getProgramInfoLog(this.program)},t.prototype.use=function(){return this.gl.useProgram(this.program),this},t.prototype.uniformLoc=function(t){var e;return void 0===(e=this.uniform_cache[t])&&(e=this.uniform_cache[t]=this.gl.getUniformLocation(this.program,t)),e},t.prototype.int=function(t,e){var i;return this.value_cache[t]!==e&&(this.value_cache[t]=e,(i=this.uniformLoc(t))&&this.gl.uniform1i(i,e)),this},t.prototype.vec2=function(t,e,i){var r;return(r=this.uniformLoc(t))&&this.gl.uniform2f(r,e,i),this},t.prototype.float=function(t,e){var i;return this.value_cache[t]!==e&&(this.value_cache[t]=e,(i=this.uniformLoc(t))&&this.gl.uniform1f(i,e)),this},t}(),t=function(){function t(t){this.gl=t,this.buffer=this.gl.createFramebuffer()}return t.prototype.destroy=function(){return this.gl.deleteFRamebuffer(this.buffer)},t.prototype.bind=function(){return this.gl.bindFramebuffer(this.gl.FRAMEBUFFER,this.buffer),this},t.prototype.unbind=function(){return this.gl.bindFramebuffer(this.gl.FRAMEBUFFER,null),this},t.prototype.check=function(){switch(this.gl.checkFramebufferStatus(this.gl.FRAMEBUFFER)){case this.gl.FRAMEBUFFER_UNSUPPORTED:throw"Framebuffer is unsupported";case this.gl.FRAMEBUFFER_INCOMPLETE_ATTACHMENT:throw"Framebuffer incomplete attachment";case this.gl.FRAMEBUFFER_INCOMPLETE_DIMENSIONS:throw"Framebuffer incomplete dimensions";case this.gl.FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT:throw"Framebuffer incomplete missing attachment"}return this},t.prototype.color=function(t){return this.gl.framebufferTexture2D(this.gl.FRAMEBUFFER,this.gl.COLOR_ATTACHMENT0,t.target,t.handle,0),this.check(),this},t.prototype.depth=function(t){return this.gl.framebufferRenderbuffer(this.gl.FRAMEBUFFER,this.gl.DEPTH_ATTACHMENT,this.gl.RENDERBUFFER,t.id),this.check(),this},t.prototype.destroy=function(){return this.gl.deleteFramebuffer(this.buffer)},t}(),n=function(){function t(t,e){var i,r;switch(this.gl=t,null==e&&(e={}),this.channels=this.gl[(null!=(i=e.channels)?i:"rgba").toUpperCase()],"number"==typeof e.type?this.type=e.type:this.type=this.gl[(null!=(r=e.type)?r:"unsigned_byte").toUpperCase()],this.channels){case this.gl.RGBA:this.chancount=4;break;case this.gl.RGB:this.chancount=3;break;case this.gl.LUMINANCE_ALPHA:this.chancount=2;break;default:this.chancount=1}this.target=this.gl.TEXTURE_2D,this.handle=this.gl.createTexture()}return t.prototype.destroy=function(){return this.gl.deleteTexture(this.handle)},t.prototype.bind=function(t){if(null==t&&(t=0),t>15)throw"Texture unit too large: "+t;return this.gl.activeTexture(this.gl.TEXTURE0+t),this.gl.bindTexture(this.target,this.handle),this},t.prototype.setSize=function(t,e){return this.width=t,this.height=e,this.gl.texImage2D(this.target,0,this.channels,this.width,this.height,0,this.channels,this.type,null),this},t.prototype.upload=function(t){return this.width=t.width,this.height=t.height,this.gl.texImage2D(this.target,0,this.channels,this.channels,this.type,t),this},t.prototype.linear=function(){return this.gl.texParameteri(this.target,this.gl.TEXTURE_MAG_FILTER,this.gl.LINEAR),this.gl.texParameteri(this.target,this.gl.TEXTURE_MIN_FILTER,this.gl.LINEAR),this},t.prototype.nearest=function(){return this.gl.texParameteri(this.target,this.gl.TEXTURE_MAG_FILTER,this.gl.NEAREST),this.gl.texParameteri(this.target,this.gl.TEXTURE_MIN_FILTER,this.gl.NEAREST),this},t.prototype.clampToEdge=function(){return this.gl.texParameteri(this.target,this.gl.TEXTURE_WRAP_S,this.gl.CLAMP_TO_EDGE),this.gl.texParameteri(this.target,this.gl.TEXTURE_WRAP_T,this.gl.CLAMP_TO_EDGE),this},t.prototype.repeat=function(){return this.gl.texParameteri(this.target,this.gl.TEXTURE_WRAP_S,this.gl.REPEAT),this.gl.texParameteri(this.target,this.gl.TEXTURE_WRAP_T,this.gl.REPEAT),this},t}(),i=function(){function e(e,i,r){var o;this.gl=e,this.width=i,this.height=r,o=this.gl.getFloatExtension({require:["renderable"]}),this.texture=new n(this.gl,{type:o.type}).bind(0).setSize(this.width,this.height).nearest().clampToEdge(),this.fbo=new t(this.gl).bind().color(this.texture).unbind()}return e.prototype.use=function(){return this.fbo.bind()},e.prototype.bind=function(t){return this.texture.bind(t)},e.prototype.end=function(){return this.fbo.unbind()},e.prototype.resize=function(t,e){return this.width=t,this.height=e,this.texture.bind(0).setSize(this.width,this.height)},e}(),a="attribute vec4 position;\nvarying vec2 texcoord;\nvoid main(){\n    texcoord = position.xy*0.5+0.5;\n    gl_Position = position;\n}",h="#ifdef GL_FRAGMENT_PRECISION_HIGH\n    precision highp int;\n    precision highp float;\n#else\n    precision mediump int;\n    precision mediump float;\n#endif\nuniform sampler2D source;\nvarying vec2 texcoord;",e=function(){function t(t,e,n,o){var s,l,u;for(this.heatmap=t,this.gl=e,this.width=n,this.height=o,this.shader=new r(this.gl,{vertex:"attribute vec4 position, intensity;\nvarying vec2 off, dim;\nvarying float vIntensity;\nuniform vec2 viewport;\n\nvoid main(){\n    dim = abs(position.zw);\n    off = position.zw;\n    vec2 pos = position.xy + position.zw;\n    vIntensity = intensity.x;\n    gl_Position = vec4((pos/viewport)*2.0-1.0, 0.0, 1.0);\n}",fragment:"#ifdef GL_FRAGMENT_PRECISION_HIGH\n    precision highp int;\n    precision highp float;\n#else\n    precision mediump int;\n    precision mediump float;\n#endif\nvarying vec2 off, dim;\nvarying float vIntensity;\nvoid main(){\n    float falloff = (1.0 - smoothstep(0.0, 1.0, length(off/dim)));\n    float intensity = falloff*vIntensity;\n    gl_FragColor = vec4(intensity);\n}"}),this.clampShader=new r(this.gl,{vertex:a,fragment:h+"uniform float low, high;\nvoid main(){\n    gl_FragColor = vec4(clamp(texture2D(source, texcoord).rgb, low, high), 1.0);\n}"}),this.multiplyShader=new r(this.gl,{vertex:a,fragment:h+"uniform float value;\nvoid main(){\n    gl_FragColor = vec4(texture2D(source, texcoord).rgb*value, 1.0);\n}"}),this.blurShader=new r(this.gl,{vertex:a,fragment:h+"uniform vec2 viewport;\nvoid main(){\n    vec4 result = vec4(0.0);\n    for(int x=-1; x<=1; x++){\n        for(int y=-1; y<=1; y++){\n            vec2 off = vec2(x,y)/viewport;\n            //float factor = 1.0 - smoothstep(0.0, 1.5, length(off));\n            float factor = 1.0;\n            result += vec4(texture2D(source, texcoord+off).rgb*factor, factor);\n        }\n    }\n    gl_FragColor = vec4(result.rgb/result.w, 1.0);\n}"}),this.nodeBack=new i(this.gl,this.width,this.height),this.nodeFront=new i(this.gl,this.width,this.height),this.vertexBuffer=this.gl.createBuffer(),this.vertexSize=8,this.maxPointCount=10240,this.vertexBufferData=new Float32Array(this.maxPointCount*this.vertexSize*6),this.vertexBufferViews=[],s=l=0,u=this.maxPointCount;0<=u?l<u:l>u;s=0<=u?++l:--l)this.vertexBufferViews.push(new Float32Array(this.vertexBufferData.buffer,0,s*this.vertexSize*6));this.bufferIndex=0,this.pointCount=0}return t.prototype.resize=function(t,e){return this.width=t,this.height=e,this.nodeBack.resize(this.width,this.height),this.nodeFront.resize(this.width,this.height)},t.prototype.update=function(){var t,e;if(this.pointCount>0)return this.gl.enable(this.gl.BLEND),this.nodeFront.use(),this.gl.bindBuffer(this.gl.ARRAY_BUFFER,this.vertexBuffer),this.gl.bufferData(this.gl.ARRAY_BUFFER,this.vertexBufferViews[this.pointCount],this.gl.STREAM_DRAW),e=this.shader.attribLocation("position"),t=this.shader.attribLocation("intensity"),this.gl.enableVertexAttribArray(1),this.gl.vertexAttribPointer(e,4,this.gl.FLOAT,!1,32,0),this.gl.vertexAttribPointer(t,4,this.gl.FLOAT,!1,32,16),this.shader.use().vec2("viewport",this.width,this.height),this.gl.drawArrays(this.gl.TRIANGLES,0,6*this.pointCount),this.gl.disableVertexAttribArray(1),this.pointCount=0,this.bufferIndex=0,this.nodeFront.end(),this.gl.disable(this.gl.BLEND)},t.prototype.clear=function(){return this.nodeFront.use(),this.gl.clearColor(0,0,0,1),this.gl.clear(this.gl.COLOR_BUFFER_BIT),this.nodeFront.end()},t.prototype.clamp=function(t,e){return this.gl.bindBuffer(this.gl.ARRAY_BUFFER,this.heatmap.quad),this.gl.vertexAttribPointer(0,4,this.gl.FLOAT,!1,0,0),this.nodeFront.bind(0),this.nodeBack.use(),this.clampShader.use().int("source",0).float("low",t).float("high",e),this.gl.drawArrays(this.gl.TRIANGLES,0,6),this.nodeBack.end(),this.swap()},t.prototype.multiply=function(t){return this.gl.bindBuffer(this.gl.ARRAY_BUFFER,this.heatmap.quad),this.gl.vertexAttribPointer(0,4,this.gl.FLOAT,!1,0,0),this.nodeFront.bind(0),this.nodeBack.use(),this.multiplyShader.use().int("source",0).float("value",t),this.gl.drawArrays(this.gl.TRIANGLES,0,6),this.nodeBack.end(),this.swap()},t.prototype.blur=function(){return this.gl.bindBuffer(this.gl.ARRAY_BUFFER,this.heatmap.quad),this.gl.vertexAttribPointer(0,4,this.gl.FLOAT,!1,0,0),this.nodeFront.bind(0),this.nodeBack.use(),this.blurShader.use().int("source",0).vec2("viewport",this.width,this.height),this.gl.drawArrays(this.gl.TRIANGLES,0,6),this.nodeBack.end(),this.swap()},t.prototype.swap=function(){var t;return t=this.nodeFront,this.nodeFront=this.nodeBack,this.nodeBack=t},t.prototype.addVertex=function(t,e,i,r,n){return this.vertexBufferData[this.bufferIndex++]=t,this.vertexBufferData[this.bufferIndex++]=e,this.vertexBufferData[this.bufferIndex++]=i,this.vertexBufferData[this.bufferIndex++]=r,this.vertexBufferData[this.bufferIndex++]=n,this.vertexBufferData[this.bufferIndex++]=n,this.vertexBufferData[this.bufferIndex++]=n,this.vertexBufferData[this.bufferIndex++]=n},t.prototype.addPoint=function(t,e,i,r){var n;return null==i&&(i=50),null==r&&(r=.2),this.pointCount>=this.maxPointCount-1&&this.update(),e=this.height-e,n=i/2,this.addVertex(t,e,-n,-n,r),this.addVertex(t,e,+n,-n,r),this.addVertex(t,e,-n,+n,r),this.addVertex(t,e,-n,+n,r),this.addVertex(t,e,+n,-n,r),this.addVertex(t,e,+n,+n,r),this.pointCount+=1},t}(),o=function(){function t(t){var i,o,s,l,u,f,g,c,d,p,_,E;_=null!=t?t:{},this.canvas=_.canvas,this.width=_.width,this.height=_.height,g=_.intensityToAlpha,u=_.gradientTexture,o=_.alphaRange,this.canvas||(this.canvas=document.createElement("canvas"));try{if(this.gl=this.canvas.getContext("experimental-webgl",{depth:!1,antialias:!1}),null===this.gl&&(this.gl=this.canvas.getContext("webgl",{depth:!1,antialias:!1}),null===this.gl))throw"WebGL not supported"}catch(t){throw"WebGL not supported"}null!=window.WebGLDebugUtils&&(console.log("debugging mode"),this.gl=WebGLDebugUtils.makeDebugContext(this.gl,(function(t,e,i){throw WebGLDebugUtils.glEnumToString(t)+" was caused by call to: "+e}))),this.gl.enableVertexAttribArray(0),this.gl.blendFunc(this.gl.ONE,this.gl.ONE),u?(p=this.gradientTexture=new n(this.gl,{channels:"rgba"}).bind(0).setSize(2,2).nearest().clampToEdge(),"string"==typeof u?((f=new Image).onload=function(){return p.bind().upload(f)},f.src=u):u.width>0&&u.height>0?p.upload(u):u.onload=function(){return p.upload(u)},l="uniform sampler2D gradientTexture;\nvec3 getColor(float intensity){\n    return texture2D(gradientTexture, vec2(intensity, 0.0)).rgb;\n}"):(p=null,l="vec3 getColor(float intensity){\n    vec3 blue = vec3(0.0, 0.0, 1.0);\n    vec3 cyan = vec3(0.0, 1.0, 1.0);\n    vec3 green = vec3(0.0, 1.0, 0.0);\n    vec3 yellow = vec3(1.0, 1.0, 0.0);\n    vec3 red = vec3(1.0, 0.0, 0.0);\n\n    vec3 color = (\n        fade(-0.25, 0.25, intensity)*blue +\n        fade(0.0, 0.5, intensity)*cyan +\n        fade(0.25, 0.75, intensity)*green +\n        fade(0.5, 1.0, intensity)*yellow +\n        smoothstep(0.75, 1.0, intensity)*red\n    );\n    return color;\n}"),null==g&&(g=!0),g?(s=(E=null!=o?o:[0,1])[0],i=E[1],c="vec4 alphaFun(vec3 color, float intensity){\n    float alpha = smoothstep("+s.toFixed(8)+", "+i.toFixed(8)+", intensity);\n    return vec4(color*alpha, alpha);\n}"):c="vec4 alphaFun(vec3 color, float intensity){\n    return vec4(color, 1.0);\n}",this.shader=new r(this.gl,{vertex:a,fragment:h+"float linstep(float low, float high, float value){\n    return clamp((value-low)/(high-low), 0.0, 1.0);\n}\n\nfloat fade(float low, float high, float value){\n    float mid = (low+high)*0.5;\n    float range = (high-low)*0.5;\n    float x = 1.0 - clamp(abs(mid-value)/range, 0.0, 1.0);\n    return smoothstep(0.0, 1.0, x);\n}\n\n"+l+"\n"+c+"\n\nvoid main(){\n    float intensity = smoothstep(0.0, 1.0, texture2D(source, texcoord).r);\n    vec3 color = getColor(intensity);\n    gl_FragColor = alphaFun(color, intensity);\n}"}),null==this.width&&(this.width=this.canvas.offsetWidth||2),null==this.height&&(this.height=this.canvas.offsetHeight||2),this.canvas.width=this.width,this.canvas.height=this.height,this.gl.viewport(0,0,this.width,this.height),this.quad=this.gl.createBuffer(),this.gl.bindBuffer(this.gl.ARRAY_BUFFER,this.quad),d=new Float32Array([-1,-1,0,1,1,-1,0,1,-1,1,0,1,-1,1,0,1,1,-1,0,1,1,1,0,1]),this.gl.bufferData(this.gl.ARRAY_BUFFER,d,this.gl.STATIC_DRAW),this.gl.bindBuffer(this.gl.ARRAY_BUFFER,null),this.heights=new e(this,this.gl,this.width,this.height)}return t.prototype.adjustSize=function(){var t,e;if(e=this.canvas.offsetWidth||2,t=this.canvas.offsetHeight||2,this.width!==e||this.height!==t)return this.gl.viewport(0,0,e,t),this.canvas.width=e,this.canvas.height=t,this.width=e,this.height=t,this.heights.resize(this.width,this.height)},t.prototype.display=function(){return this.gl.bindBuffer(this.gl.ARRAY_BUFFER,this.quad),this.gl.vertexAttribPointer(0,4,this.gl.FLOAT,!1,0,0),this.heights.nodeFront.bind(0),this.gradientTexture&&this.gradientTexture.bind(1),this.shader.use().int("source",0).int("gradientTexture",1),this.gl.drawArrays(this.gl.TRIANGLES,0,6)},t.prototype.update=function(){return this.heights.update()},t.prototype.clear=function(){return this.heights.clear()},t.prototype.clamp=function(t,e){return null==t&&(t=0),null==e&&(e=1),this.heights.clamp(t,e)},t.prototype.multiply=function(t){return null==t&&(t=.95),this.heights.multiply(t)},t.prototype.blur=function(){return this.heights.blur()},t.prototype.addPoint=function(t,e,i,r){return this.heights.addPoint(t,e,i,r)},t.prototype.addPoints=function(t){var e,i,r,n;for(n=[],i=0,r=t.length;i<r;i++)e=t[i],n.push(this.addPoint(e.x,e.y,e.size,e.intensity));return n},t}(),window.createWebGLHeatmap=function(t){return new o(t)}}).call(this)}};t[839](),t[886]()})();