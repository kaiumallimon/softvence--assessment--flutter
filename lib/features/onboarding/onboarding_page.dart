import 'package:assessment/common_widgets/custom_button.dart';
import 'package:assessment/constants/assets.dart';
import 'package:assessment/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  // States
  late PageController? _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    initPageController();
  }

  /* Onboarding data, containing image, title and a subtitle in each */
  final List<Map<String, String>> _onboardingData = [
    {
      "image": AppAssets.onboardingAsset1,
      "title": AppStrings.onboardingTitle1,
      "subtitle": AppStrings.onboardingSubtitle1,
    },
    {
      "image": AppAssets.onboardingAsset2,
      "title": AppStrings.onboardingTitle2,
      "subtitle": AppStrings.onboardingSubtitle2,
    },
    {
      "image": AppAssets.onboardingAsset3,
      "title": AppStrings.onboardingTitle3,
      "subtitle": AppStrings.onboardingSubtitle3,
    },
  ];

  /* Initialize PageController */
  void initPageController() {
    _pageController = PageController(initialPage: _currentPage);
  }

  /* Navigate to next page or finish onboarding */
  void goToNextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController?.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // Background color
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _onboardingData.length,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (pageIndex) {
                // Update current page index state
                setState(() {
                  _currentPage = pageIndex;
                });
              },
              itemBuilder: (context, index) {
                final currentPageData = _onboardingData[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadiusGeometry.horizontal(
                        left: Radius.circular(40),
                        right: Radius.circular(40),
                      ),
                      child: Stack(
                        children: [
                          // Image
                          _buildImage(currentPageData: currentPageData),
                          // Skip button
                          _buildSkipButton(theme: theme),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTitle(currentPageData: currentPageData, theme: theme),
                    const SizedBox(height: 10),
                    _buildSubtitle(
                      currentPageData: currentPageData,
                      theme: theme,
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          // Indicator
          _buildPageIndicator(),

          const SizedBox(height: 20),
          // Next button
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildImage({required Map<String, String> currentPageData}) {
    return Image.asset(
      currentPageData["image"] ?? "",
      width: double.infinity,
      height: 429,
      fit: BoxFit.cover,
    );
  }

  Widget _buildSkipButton({required ThemeData theme}) {
    return Positioned(
      top: 32,
      right: 10,
      child: TextButton(
        onPressed: () {},
        child: Text(
          'Skip',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.poppins().fontFamily,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                offset: const Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
    
  }

  Widget _buildTitle({
    required Map<String, String> currentPageData,
    required ThemeData theme,
  }){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        currentPageData["title"] ?? "",
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
          fontWeight: FontWeight.w500,
          fontFamily: GoogleFonts.poppins().fontFamily,
          color: theme.textTheme.bodyLarge?.color,
        ),
      ),
    );
  }

  Widget _buildSubtitle({
    required Map<String, String> currentPageData,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        currentPageData["subtitle"] ?? "",
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontFamily: GoogleFonts.oxygen().fontFamily,
          color: theme.textTheme.bodyLarge?.color,
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _onboardingData.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          width: 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? Theme.of(context).primaryColor
                : Colors.grey,
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 40.0),
      child: CustomButton(
        text: "Next",
        height: 50,
        width: double.infinity,
        onPressed: goToNextPage,
      ),
    );
  }
}

