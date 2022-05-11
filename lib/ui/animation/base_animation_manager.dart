import 'package:flutter/material.dart';

abstract class BaseAnimationManager{
  init({required tickerProvider}){
    initControllers(tickerProvider: tickerProvider);
    initAnimations();
  }
  initControllers({required tickerProvider});
  initAnimations();
  startEnterAnimation();
  dispose();
}