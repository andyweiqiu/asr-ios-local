# asr-ios-local

## 中文说明
基于kaldi的ios本地语音识别，整个识别的过程都在本地完成，不需要通过网络传输到服务器解码。

教程https://www.jianshu.com/u/3c2a0bd52ebc

由于kaldi-ios.a和final.mdl文件比较大，没有上传（这里需要自行编译iOS库，替换自己的模型文件，不再提供静态库和模型文件，如在编译过程中有问题，可以打开问题讨论）。

该demo是将kaldi本地化，直接在iOS本地进行识别，支持实时流，支持跨平台，识别速度快，支持中文和英文模型。

只要替换你的模型，就可以用这个demo来测试你的模型了，不需要你去关注其他的东西。

## English description
Based on Kaldi's ios local speech recognition, the whole recognition process is done locally, which does not need to be transmitted to the server for decoding over the network.

Tutorial: https://www.jianshu.com/u/3c2a0bd52ebc

Because the kaldi-ios.a and final.dml files are relatively large, they have not been uploaded.

This demo is to localize Kaldi and recognize it directly in iOS. It supports real-time streaming, cross-platform support, fast recognition and supports Chinese and English models.

Just replace your model, and you can use this demo to test your model without having to worry about anything else.

