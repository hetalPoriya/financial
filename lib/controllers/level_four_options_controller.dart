import 'package:financial/models/level_four_options_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LevelFourOptionsController extends GetxController {
  var pageController = PageController();
  var levelFourIndex = 0.obs;
  var optionsIndex = 0.0.obs;

  bool get isLastPage => levelFourIndex.value == bills.length - 1;

  forwardFunction() {
    pageController.nextPage(
        duration: Duration(seconds: 1), curve: Curves.easeIn);
  }

  List<LevelFourOptions> bills = [
    LevelFourOptions(
        text: 'WHERE WILL YOU LIVE?',
        step: 'STEP 01',
        options1: 'Studio \nApartment ',
        options2: 'Mid-Rise \nApartment ',
        options3: 'Upscale \nCondo ',
        options4: 'Luxury \nHouse ',
        options5: 'Suburban \nHouse ',
        //isSelectedButton: 0,
        isSelectedOption: 0,
        optionsValue: [
          OptionsValue(
              description:
                  'Rent a Studio Apartment in downtown. Close to Stores, Gym, Restaurants & Work.',
              rent: 200,
              //emi: 100,
              image: 'assets/studioApartment.png',
              bottomText:
                  'Tip: Distance from amenities & work will impact your monthly transport expense'),
          OptionsValue(
              description:
                  'Rent a 1 Bedroom Apartment in Downtown.  Walkable distance from Grocery stores, Restaurants, Local Gym & Work.',
              rent: 300,
              image: 'assets/midRiseApartment.png',
              bottomText:
                  'Tip: Distance from amenities & work will impact your monthly transport expense'),
          OptionsValue(
              description:
                  'Rent a 2 Bedroom Apartment in Upscale Building. Has a Gym, Sports facilities & shared pool. Medium distance from Work',
              rent: 500,
              image: 'assets/upscaleApartment.png',
              bottomText:
                  'Tip: Distance from amenities & work will impact your monthly transport expense'),
          OptionsValue(
              description:
                  'Luxury house in Posh Suburb. Close to shopping center, Gym & Hospital. Far from Work',
              rent: 400,
              image: 'assets/luxuryHouse.png',
              bottomText:
                  'Tip: Distance from amenities & work will impact your monthly transport expense'),
          OptionsValue(
              description:
                  '3 bedroom  house in upcoming Suburb. No Facilities nearby. Far from Work.',
              rent: 300,
              image: 'assets/suburbanHouse.png',
              bottomText:
                  'Tip: Distance from amenities & work will impact your monthly transport expense')
        ]),
    LevelFourOptions(
        step: 'STEP 02',
        text: 'HOW WILL YOU TRAVEL?',
        options1: 'Economy ',
        options2: 'Plus ',
        options3: 'Premium ',
        //options4: 'New \nSUV car ',
        // isSelectedButton: 0,
        isSelectedOption: 0,
        optionsValue: [
          OptionsValue(
              description:
                  ' Travel using a city bus, subway or other forms of public transportation.',
              rent: 200,
              image: 'assets/transport1.png',
              bottomText:
                  ' Public transport is cheap but commute times are longer and will lead to lower quality of life points. '),
          OptionsValue(
              description:
                  ' Travel using public transport and use taxis occasionally.',
              rent: 350,
              image: 'assets/transport2.png',
              bottomText:
                  'Use public transport as your primary mode of transport and use taxis in case of emergency.'),
          OptionsValue(
              description:
                  ' Travel using private cabs. Save time and enjoy a comfortable commute.',
              rent: 500,
              image: 'assets/transport3.png',
              bottomText:
                  'Travel using taxis to save time and increased comfort. Earn high quality of life points.'),
          // OptionsValue(
          //     description:
          //     'This brand new vehicle has no prior owner. The car is in mint condition and has premium features and options, such as power windows, four-wheel drive, keyless entry and sunroof.',
          //     rent: 550,
          //     image: 'assets/luxuryHouse.png')
        ]),
    LevelFourOptions(
        text: 'CHOOSE YOUR LIFESTYLE',
        step: 'STEP 03',
        options1: 'Economy ',
        options2: 'Plus ',
        options3: 'Premium ',
        //isSelectedButton: 0,
        isSelectedOption: 0,
        optionsValue: [
          OptionsValue(
              description: ' Organic groceries.  affordable cellphone and internet plans. Shop and eat out once a month.',
              rent: 300,
              image: 'assets/lifestyle1.png',
               bottomText:''
              // 'Tip: Distance from amenities & work will impact your monthly transport expense'
        ),
          OptionsValue(
              description: 'Gourmet groceries, unlimited cellphone and internet plans. Shop and eat out often.',
              rent: 400,
              image: 'assets/lifestyle2.png',
               bottomText:''
              // 'Tip: Distance from amenities & work will impact your monthly transport expense'
          ),
          OptionsValue(
              description: 'Basic quality groceries, budget cellphone and internet plans, shop only on sale.',
              rent: 600,
              image: 'assets/lifestyle3.png',
               bottomText:''
              // 'Tip: Distance from amenities & work will impact your monthly transport expense'
          )
        ]),
  ];
}
