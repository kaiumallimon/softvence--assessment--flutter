import './_onboarding.dart';

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
    } else {
      goToLocationPage();
    }
  }

  /* Navigate to location page and replace current page */
  void goToLocationPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LocationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    /* Theme and responsive helpers */
    final theme = Theme.of(context);
    final responsive = ResponsiveHelper(context);

    return Scaffold(
      /* Background color */
      backgroundColor: theme.scaffoldBackgroundColor,
      
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                physics: const NeverScrollableScrollPhysics(),

                /* Update current page index on page change */
                onPageChanged: (pageIndex) {
                  setState(() {
                    _currentPage = pageIndex;
                  });
                },
                
                itemBuilder: (context, index) {
                  final currentPageData = _onboardingData[index];
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Flexible image
                        Stack(
                          children: [
                            /* Onboarding image */
                            _buildImage(currentPageData: currentPageData),
                            /* Skip button */
                            _buildSkipButton(
                              theme: theme,
                              responsive: responsive,
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 20),
                       
                        /* Title */
                        _buildTitle(
                          currentPageData: currentPageData,
                          theme: theme,
                          responsive: responsive,
                        ),

                        const SizedBox(height: 10),
                        
                        /* Subtitle */
                        _buildSubtitle(
                          currentPageData: currentPageData,
                          theme: theme,
                          responsive: responsive,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            /* Page indicator dots */
            _buildPageIndicator(),
            const SizedBox(height: 20),
            /* Next button */
            _buildNextButton(),
          ],
        ),
      ),
    );
  }

  /* Onboarding image with rounded bottom corners */
  Widget _buildImage({required Map<String, String> currentPageData}) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
      child: Image.asset(
        currentPageData["image"] ?? "",
        width: double.infinity,
        height:
            MediaQuery.of(context).size.height * 0.5, // scale on small devices
        fit: BoxFit.cover,
      ),
    );
  }

  /* Skip button */
  Widget _buildSkipButton({
    required ThemeData theme,
    required ResponsiveHelper responsive,
  }) {
    return Positioned(
      top: 32,
      right: 10,
      child: TextButton(
        onPressed: goToLocationPage,
        child: Text(
          AppStrings.skipButton,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontSize: responsive.scaleFont(16),
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

  /* Title */
  Widget _buildTitle({
    required Map<String, String> currentPageData,
    required ThemeData theme,
    required ResponsiveHelper responsive,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        currentPageData["title"] ?? "",
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
          fontWeight: FontWeight.w500,
          fontFamily: GoogleFonts.poppins().fontFamily,
          color: theme.textTheme.bodyLarge?.color,
          fontSize: responsive.scaleFont(30),
        ),
      ),
    );
  }
  
  /* Subtitle */
  Widget _buildSubtitle({
    required Map<String, String> currentPageData,
    required ThemeData theme,
    required ResponsiveHelper responsive,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        currentPageData["subtitle"] ?? "",
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontFamily: GoogleFonts.oxygen().fontFamily,
          color: theme.textTheme.bodyLarge?.color,
          fontSize: responsive.scaleFont(14),
        ),
      ),
    );
  }

  /* Page indicator dots */
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

  /* Next button:
      - Navigates to next page or
      - Finishes onboarding on last page
   */
  Widget _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 40.0),
      child: CustomButton(
        text: AppStrings.nextButton,
        height: 50,
        width: double.infinity,
        onPressed: goToNextPage,
      ),
    );
  }
}
