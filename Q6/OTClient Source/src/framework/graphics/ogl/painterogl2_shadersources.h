/*
 * Copyright (c) 2010-2020 OTClient <https://github.com/edubart/otclient>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#ifndef PAINTEROGL2_SHADERSOURCES_H
#define PAINTEROGL2_SHADERSOURCES_H

static const std::string glslMainVertexShader = "\n\
    highp vec4 calculatePosition();\n\
    void main() {\n\
        gl_Position = calculatePosition();\n\
    }\n";

static const std::string glslMainWithTexCoordsVertexShader = "\n\
    attribute highp vec2 a_TexCoord;\n\
    uniform highp mat3 u_TextureMatrix;\n\
    varying highp vec2 v_TexCoord;\n\
    highp vec4 calculatePosition();\n\
    void main()\n\
    {\n\
        gl_Position = calculatePosition();\n\
        v_TexCoord = (u_TextureMatrix * vec3(a_TexCoord,1.0)).xy;\n\
    }\n";

static std::string glslPositionOnlyVertexShader = "\n\
    attribute highp vec2 a_Vertex;\n\
    uniform highp mat3 u_TransformMatrix;\n\
    uniform highp mat3 u_ProjectionMatrix;\n\
    highp vec4 calculatePosition() {\n\
        return vec4(u_ProjectionMatrix * u_TransformMatrix * vec3(a_Vertex.xy, 1.0), 1.0);\n\
    }\n";

static const std::string glslMainFragmentShader = "\n\
    uniform lowp float u_Opacity;\n\
    lowp vec4 calculatePixel();\n\
    void main()\n\
    {\n\
        gl_FragColor = calculatePixel();\n\
        gl_FragColor.a *= u_Opacity;\n\
    }\n";


static const std::string glslTextureSrcFragmentShader = "\n\
    varying mediump vec2 v_TexCoord;\n\
    uniform lowp vec4 u_Color;\n\
    uniform sampler2D u_Tex0;\n\
    lowp vec4 calculatePixel() {\n\
        return texture2D(u_Tex0, v_TexCoord) * u_Color;\n\
    }\n";

static const std::string glslOpacityFragmentShader = "\n\
    uniform sampler2D u_Tex0;\n\
    uniform lowp float u_Opacity;\n\
    varying mediump vec2 v_TexCoord;\n\
    void main()\n\
    {\n\
        vec4 col = texture2D(u_Tex0, v_TexCoord);\n\
        if (col.a > 0.001)\n\
            col.a = u_Opacity;\n\
        gl_FragColor = col;\n\
    }\n";

static const std::string glslSolidColorFragmentShader = "\n\
    uniform lowp vec4 u_Color;\n\
    lowp vec4 calculatePixel() {\n\
        return u_Color;\n\
    }\n";

// Outline code inspired by Mehah's solid outline shader
static const std::string glslOutlineFragmentShader = "\n\
    uniform sampler2D u_Tex0;\n\
    varying mediump vec2 v_TexCoord;\n\
    const float offset = 0.001;\n\
    void main()\n\
    {\n\
        vec4 col = texture2D(u_Tex0, v_TexCoord);\n\
        float a = texture2D(u_Tex0, vec2(v_TexCoord.x + offset, v_TexCoord.y)).a +\n\
                                 texture2D(u_Tex0, vec2(v_TexCoord.x, v_TexCoord.y - offset)).a +\n\
                                 texture2D(u_Tex0, vec2(v_TexCoord.x - offset, v_TexCoord.y)).a +\n\
                                 texture2D(u_Tex0, vec2(v_TexCoord.x, v_TexCoord.y + offset)).a;\n\
        if (a > 0 && col.a < 1.0) {\n\
            gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);\n\
        } else {\n\
            gl_FragColor = col;\n\
        }\n\
    }\n";

#endif
