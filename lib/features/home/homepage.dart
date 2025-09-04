import './_home.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  /* Address and Loading State */
  String? _address;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initAlarm();
    _fetchAddress();
  }

  /* Initialize Alarm System */
  Future<void> _initAlarm() async {
    await AlarmHelper.initialize();
    Alarm.ringStream.stream.listen((alarmSettings) {
      _onAlarmRing(alarmSettings.id);
    });
  }

  /* Fetch Address from Current Location */
  Future<void> _fetchAddress() async {
    final locationProvider = Provider.of<LocationProvider>(
      context,
      listen: false,
    );
    final locationService = LocationService();

    if (locationProvider.currentLocation != null) {
      final pos = locationProvider.currentLocation!;
      final address = await locationService.getAddressFromLatLng(
        pos.latitude,
        pos.longitude,
      );
      setState(() {
        _address = address;
        _loading = false;
      });
    } else {
      setState(() {
        _address = AppStrings.noLocation;
        _loading = false;
      });
    }
  }

  /* Handle Alarm Ringing */
  Future<void> _onAlarmRing(int id) async {
    if (!mounted) return;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.secondaryButtonColor,
        title: Text(AppStrings.alarmStopDialogTitle),
        content: Text(AppStrings.alarmStopDialogSubtitle),
        actions: [
          TextButton(
            onPressed: () {
              AlarmHelper.stopAlarm(id);
              Navigator.pop(context);
            },
            child: Text(AppStrings.stopButton),
          ),
        ],
      ),
    );
  }

  /* Schedule Alarm */
  Future<void> _scheduleAlarm(DateTime alarmTime) async {
    await AlarmHelper.setAlarm(alarmTime);
    setState(() {});
  }

  /* Show Time Picker */
  Future<void> _showTimePicker() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary:  AppColors.primaryColor,
              secondary: AppColors.primaryColor,
              onPrimary: Colors.white,
              onSecondary: Colors.white,
              onSurface: Colors.white,
              surface: AppColors.secondaryButtonColor
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      final now = DateTime.now();
      DateTime alarmTime = DateTime(
        now.year,
        now.month,
        now.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      if (alarmTime.isBefore(now)) {
        alarmTime = alarmTime.add(const Duration(days: 1));
      }

      await _scheduleAlarm(alarmTime);
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* Location Card */
            Center(child: _buildLocationCard(theme)),
            const SizedBox(height: 20),
            /* Alarms Section Title */
            _buildAlarmsSectionTitle(theme),

            const SizedBox(height: 10),
            /* Alarms List Body */
            _buildAlarmsListBody(),
          ],
        ),
      ),
    );
  }

  /* Alarms List Body */
  Expanded _buildAlarmsListBody() {
    return Expanded(
      /* Listening to Hive box for alarm changes */
      child: ValueListenableBuilder(
        valueListenable: Hive.box<Map>(HiveDBHelper.alarmBox).listenable(),
        builder: (context, Box<Map> box, _) {
          if (box.values.isEmpty) {
            return const Center(child: Text(AppStrings.noAlarms));
          }

          /* Fetching all alarms from Hive box */
          final alarms = box.values.toList();

          return ListView.builder(
            itemCount: alarms.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              /* Parsing alarm data */
              final alarm = alarms[index];
              final time = DateTime.parse(alarm["time"]);
              final id = alarm["id"];
              final enabled = alarm["enabled"] ?? true;

              /* Alarm Card */
              return _buildAlarmCard(time, context, enabled, id);
            },
          );
        },
      ),
    );
  }

  /* Alarms Section Title */
  Padding _buildAlarmsSectionTitle(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        AppStrings.alarmsSectionTitle,
        style: theme.textTheme.titleMedium?.copyWith(
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /*Location Card: Containing Location Information and Alarm Button*/
  Container _buildLocationCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      width: 264,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.locationTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          _buildLocationRow(theme),
          const SizedBox(height: 15),
          _buildAddAlarmButton(),
        ],
      ),
    );
  }

  /*Location Row: Containing Location Icon and Address*/
  Row _buildLocationRow(ThemeData theme) {
    return Row(
      children: [
        Image.asset(AppAssets.locationIcon, width: 24, height: 24),
        const SizedBox(width: 8),
        _loading
            ? SizedBox(
                height: 20,
                width: 20,
                child: const CircularProgressIndicator.adaptive(
                  strokeWidth: 1.5,
                ),
              )
            : Expanded(
                child: Text(
                  _address ?? AppStrings.noLocation,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: GoogleFonts.oxygen().fontFamily,
                  ),
                ),
              ),
      ],
    );
  }

  /*Add Alarm Button*/
  CustomButton _buildAddAlarmButton() {
    return CustomButton(
      text: AppStrings.addAlarmButton,
      onPressed: () async => await _showTimePicker(),
      height: 48,
      backgroundColor: AppColors.secondaryButtonColor,
    );
  }

  /*Alarm Card: Containing Alarm Time, Date and Switch*/
  Container _buildAlarmCard(DateTime time, BuildContext context, enabled, id) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondaryButtonColor,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildAlarmTime(time, context),

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAlarmDate(time, context),
                const SizedBox(width: 8),
                _buildSwitch(enabled, id),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /*Alarm Time Text*/
  Text _buildAlarmTime(DateTime time, BuildContext context) {
    return Text(
      FormattingHelper.formatTime(time),
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /*Alarm Date Text*/
  Text _buildAlarmDate(DateTime time, BuildContext context) {
    return Text(
      FormattingHelper.formatDate(time),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
    );
  }

  /*Alarm Enable/Disable Switch*/
  Switch _buildSwitch(enabled, id) {
    return Switch(
      value: enabled,
      onChanged: (value) async {
        AlarmHelper.deleteAlarm(id);
        setState(() {});
      },
    );
  }
}
