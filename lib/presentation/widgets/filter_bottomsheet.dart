import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_news_app/controllers/state_controller.dart';
import 'package:global_news_app/data/models/news_model.dart';
import 'package:global_news_app/data/services/api_data_service.dart';
import 'package:global_news_app/utils/constants/size.dart';
import 'package:global_news_app/utils/constants/text_style.dart';
import 'package:global_news_app/utils/constants/theme.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet>
    with AutomaticKeepAliveClientMixin<FilterBottomSheet> {
  final StateController stateController = Get.find();

  // String? selectedMainCategory = "top-headlines";
  // String? selectedSubCategory;
  // String? selectedSource;
  // String? selectedCountry;
  // String? selectedCountryKey;

  Map<String, String> mainCategories = {
    // "Everything": "everything",
    "Top Headlines": "top-headlines",
  };

  Map<String, String> subCategories = {
    "Business": "business",
    "Entertainment": "entertainment",
    "Health": "health",
    "Sports": "sports",
    "Science": "science",
    "Technology": "technology",
  };

  Map<String, String> sources = {
    "ABC News": "abc-news",
    "BBC News": "bbc-news",
    "Bloomberg": "bloomberg",
    "ESPN": "espn",
    "IGN": "ign",
    "TIME": "time",
  };

  Map<String, String?> countries = {
    "Select a country": null,
    "United States": "us",
    "Canada": "ca",
    "United Kingdom": "gb",
    "Australia": "au",
  };

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        // Fixed Header
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: CFGSize.bodyLRPadding, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Filter Articles",
                style: TextStyle(
                  fontSize: CFGTextStyle.titleFontSize,
                  fontWeight: CFGTextStyle.mediumFontWeight,
                  color: CFGTextStyle.defaultFontColor,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
        //
        const Divider(height: 1),

        // Scrollable Content
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: CFGSize.bodyLRPadding),
            child: ListView(
              children: [
                const SizedBox(height: 8),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: mainCategories.keys.map((category) {
                    return FilterChip(
                      label: Text(category),
                      selected: stateController.selectedMainCategory ==
                          mainCategories[category],
                      selectedColor: Colors.blue.shade200,
                      onSelected: (selected) {
                        if (selected) {
                          // Update the selectedCategory to the selected category
                          stateController.selectedMainCategory =
                              mainCategories[category];
                        }
                        // else {
                        //   // If deselected, set the selectedCategory to null
                        //   selectedMainCategory = null;
                        // }
                        debugPrint(stateController.selectedMainCategory);

                        // Rebuild the UI by calling setState on the parent widget
                        (context as Element).markNeedsBuild();
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                // Category
                Text(
                  "Category",
                  style: TextStyle(
                    fontSize: CFGTextStyle.smallTitleFontSize,
                    fontWeight: CFGTextStyle.mediumFontWeight,
                    color: CFGTextStyle.defaultFontColor,
                  ),
                ),

                const SizedBox(height: 8),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: subCategories.keys.map((category) {
                    bool isEnabled = stateController.selectedSource == null;
                    return FilterChip(
                      label: Text(category),
                      selected: stateController.selectedSubCategory ==
                          subCategories[category],
                      selectedColor: Colors.blue.shade200,
                      onSelected: isEnabled
                          ? (selected) {
                              if (selected) {
                                // Update the selectedCategory to the selected key's value
                                stateController.selectedSubCategory =
                                    subCategories[category];
                              } else {
                                // If deselected, set the selectedCategory to null
                                stateController.selectedSubCategory = null;
                              }
                              debugPrint(stateController.selectedSubCategory);
                              // Rebuild the UI by calling setState on the parent widget
                              (context as Element).markNeedsBuild();
                            }
                          : null,
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                // Sources
                Text(
                  "Sources",
                  style: TextStyle(
                    fontSize: CFGTextStyle.smallTitleFontSize,
                    fontWeight: CFGTextStyle.mediumFontWeight,
                    color: CFGTextStyle.defaultFontColor,
                  ),
                ),

                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: sources.keys.map((category) {
                    bool isEnabled =
                        (stateController.selectedSubCategory == null &&
                            stateController.selectedCountry == null);
                    return FilterChip(
                      label: Text(category),
                      selected:
                          stateController.selectedSource == sources[category],
                      selectedColor: Colors.blue.shade200,
                      onSelected: isEnabled
                          ? (selected) {
                              if (selected) {
                                // Update the selectedCategory to the selected category
                                stateController.selectedSource =
                                    sources[category];
                                //Resetting Dropdown value
                                setState(() {
                                  if (stateController.selectedSource != null) {
                                    stateController.selectedCountryKey = null;
                                    stateController.selectedCountry = null;
                                    debugPrint(stateController.selectedCountry);
                                  }
                                });
                              } else {
                                // If deselected, set the selectedCategory to null
                                stateController.selectedSource = null;
                              }
                              debugPrint(stateController.selectedSource);

                              // Rebuild the UI by calling setState on the parent widget
                              (context as Element).markNeedsBuild();
                            }
                          : null,
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                Text(
                  "Country",
                  style: TextStyle(
                    fontSize: CFGTextStyle.smallTitleFontSize,
                    fontWeight: CFGTextStyle.mediumFontWeight,
                    color: CFGTextStyle.defaultFontColor,
                  ),
                ),

                const SizedBox(height: 8),

                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.15),
                  child: DropdownButton<String>(
                    value: stateController.selectedCountryKey,
                    hint: Text(
                      "Select a country",
                      style: TextStyle(
                        fontSize: CFGTextStyle.smallTitleFontSize,
                        fontWeight: CFGTextStyle.mediumFontWeight,
                        color: CFGTextStyle.lightGreyFontColor,
                      ),
                    ),
                    onChanged: stateController.selectedSource == null
                        ? (String? newValue) {
                            setState(() {
                              stateController.selectedCountryKey = newValue;
                              stateController.selectedCountry =
                                  countries[newValue];
                            });
                            debugPrint(stateController.selectedCountry);
                            // Rebuild the UI by calling setState on the parent widget
                            (context as Element).markNeedsBuild();
                          }
                        : null,
                    items: countries.keys
                        .map<DropdownMenuItem<String>>((String country) {
                      return DropdownMenuItem<String>(
                        alignment: AlignmentDirectional.center,
                        value: country,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              country,
                              style: TextStyle(
                                fontSize: CFGTextStyle.smallTitleFontSize,
                                fontWeight: CFGTextStyle.mediumFontWeight,
                                color: CFGTextStyle.defaultFontColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    borderRadius: BorderRadius.circular(CFGSize.tileRadius),
                    alignment: AlignmentDirectional.center,
                    padding: const EdgeInsets.only(bottom: 5),
                    isExpanded: true,
                    dropdownColor: CFGTheme.bgColorScreen,
                    style: TextStyle(
                      fontSize: CFGTextStyle.smallTitleFontSize,
                      fontWeight: CFGTextStyle.mediumFontWeight,
                      color: CFGTextStyle.defaultFontColor,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Reset filters
                        stateController.selectedMainCategory = "top-headlines";
                        stateController.selectedSubCategory = null;
                        stateController.selectedSource = null;
                        stateController.selectedCountry = null;
                        stateController.selectedCountryKey = null;
                        (context as Element).markNeedsBuild();
                      },
                      style: ButtonStyle(
                          side: WidgetStatePropertyAll(
                              BorderSide(color: CFGTheme.buttonOverlay)),
                          backgroundColor:
                              WidgetStatePropertyAll(CFGTheme.buttonLightGrey)),
                      child: Text(
                        "Reset",
                        style: TextStyle(
                          fontSize: CFGTextStyle.defaultFontSize,
                          fontWeight: CFGTextStyle.mediumFontWeight,
                          color: CFGTextStyle.defaultFontColor,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Apply filters and get from API
                        List<NewsModel> newsList = await ApiDataService()
                            .getNewsByCategory(
                                mainCategory:
                                    stateController.selectedMainCategory,
                                subCategory:
                                    stateController.selectedSubCategory,
                                source: stateController.selectedSource,
                                country: stateController.selectedCountry);
                        //Returning news list
                        Get.back(result: newsList);
                      },
                      style: ButtonStyle(
                          side: WidgetStatePropertyAll(
                              BorderSide(color: CFGTheme.button)),
                          backgroundColor:
                              WidgetStatePropertyAll(CFGTheme.bgColorScreen)),
                      child: Text(
                        "Apply Filters",
                        style: TextStyle(
                          fontSize: CFGTextStyle.defaultFontSize,
                          fontWeight: CFGTextStyle.mediumFontWeight,
                          color: CFGTextStyle.defaultFontColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
