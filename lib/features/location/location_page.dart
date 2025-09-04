
import '_location.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  /* State variables */
  String errorMessage = "";
  bool isLoading = false;

  /* Initialize location service and handle errors gracefully */
  Future<void> _initLocationService(LocationProvider provider) async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {
      /* Request location permission */
      final Position? position = await LocationService.getCurrentLocation();
      /* If successful, update provider */
      provider.setCurrentLocation(position);
    } catch (error) {
      /* Error handling */
      setState(() {
        errorMessage = error.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /* Handle Home button tap */
  Future<void> _onHomePressed(LocationProvider provider) async {
    if (provider.currentLocation != null) {
      /* If location is available, navigate to homepage */
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Homepage()),
      );
      return;
    }

    /* If location not available, show dialog */
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text('Location Permission Required'),
        content: const Text(
          'Location permission is denied. Please allow location from settings to continue.',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    /* Theme and Responsive helpers */
    final theme = Theme.of(context);
    final responsive = ResponsiveHelper(context);

    /* Location provider */
    final locationProvider = Provider.of<LocationProvider>(
      context,
      listen: false,
    );

    /* Set system UI overlay styles */
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: theme.scaffoldBackgroundColor,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: theme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.scalePadding(16),
            vertical: responsive.scalePadding(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /* Title */
              _buildTitle(theme, responsive),

              SizedBox(height: responsive.scaleHeight(20)),

              /* Subtitle */
              _buildSubtitle(theme, responsive),

              SizedBox(height: responsive.scaleHeight(40)),

              /* Avatar Image */
              _buildAvatarImage(responsive),

              SizedBox(height: responsive.scaleHeight(20)),

              /* Error message */
              if (errorMessage.isNotEmpty)
                _buildErrorMessage(responsive),

              SizedBox(height: responsive.scaleHeight(20)),

              /* Location Permission Button */
              _buildLocationPermissionButton(responsive, locationProvider),

              const SizedBox(height: 10),
              /* Home Button */
              _buildHomeButton(responsive, locationProvider),
            ],
          ),
        ),
      ),
    );
  }

  /* Title */
  Text _buildTitle(ThemeData theme, ResponsiveHelper responsive) {
    return Text(
              AppStrings.permissionPageTitle,
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyLarge?.color,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: responsive.scaleFont(28),
              ),
            );
  }

  /* Subtitle */
  Text _buildSubtitle(ThemeData theme, ResponsiveHelper responsive) {
    return Text(
              AppStrings.permissionPageSubtitle,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.textTheme.bodyLarge?.color,
                fontFamily: GoogleFonts.oxygen().fontFamily,
                fontSize: responsive.scaleFont(14),
              ),
            );
  }

  /* Avatar Image */
  Flexible _buildAvatarImage(ResponsiveHelper responsive) {
    return Flexible(
              fit: FlexFit.loose,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  responsive.scaleWidth(40),
                ),
                child: Image.asset(
                  AppAssets.locationAvatar,
                  width: double.infinity,
                  height: responsive.scaleHeight(800),
                  fit: BoxFit.contain,
                ),
              ),
            );
  }

  /* Error Message */
  Text _buildErrorMessage(ResponsiveHelper responsive) {
    return Text(
                errorMessage,
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: GoogleFonts.oxygen().fontFamily,
                  fontSize: responsive.scaleFont(14),
                ),
                textAlign: TextAlign.center,
              );
  }
  
  /* Location Permission Button*/
  CustomButton _buildLocationPermissionButton(ResponsiveHelper responsive, LocationProvider locationProvider) {
    return CustomButton(
              text: isLoading
                  ? "Getting Location..."
                  : AppStrings.allowLocationButton,
              height: responsive.scaleHeight(56),
              width: double.infinity,
              backgroundColor: AppColors.secondaryButtonColor,
              trailing: isLoading
                  ? SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator.adaptive(
                        backgroundColor: Colors.white,
                        strokeWidth: 1.5,
                      ),
                    )
                  : Image.asset(
                      AppAssets.locationIcon,
                      width: responsive.scaleWidth(24),
                      height: responsive.scaleHeight(24),
                    ),
              onPressed: isLoading
                  ? () {}
                  : () {
                      _initLocationService(locationProvider);
                    },
            );
  }
  /* Home Button*/
  CustomButton _buildHomeButton(ResponsiveHelper responsive, LocationProvider locationProvider) {
    return CustomButton(
              text: AppStrings.homeButton,
              height: responsive.scaleHeight(56),
              width: double.infinity,
              backgroundColor: AppColors.secondaryButtonColor,
              onPressed: () async => await _onHomePressed(locationProvider),
            );
  }
}
