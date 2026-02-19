import 'dart:async';

import 'package:alnas_doctor/core/config/alnas_theme.dart';
import 'package:alnas_doctor/features/home/data/models/patient_model.dart';
import 'package:alnas_doctor/features/home/view_model/get_all_patients/get_all_patients_cubit.dart';
import 'package:alnas_doctor/features/home/view_model/search_patients/search_patients_cubit.dart';
import 'package:alnas_doctor/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/home_header.dart';
import '../widgets/patient_card.dart';

class PatientsView extends StatefulWidget {
  const PatientsView({super.key});

  @override
  State<PatientsView> createState() => _PatientsViewState();
}

class _PatientsViewState extends State<PatientsView> {
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  Timer? _debounceTimer;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Fetch first page on init
    context.read<GetAllPatientsCubit>().getAllPatients();

    // Listen for scroll to trigger loading more
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    if (_isSearching) {
      context.read<SearchPatientsCubit>().reset();
      context.read<SearchPatientsCubit>().searchPatients(search: _searchQuery);
    } else {
      context.read<GetAllPatientsCubit>().refresh();
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Near the bottom — load more
      if (_isSearching) {
        context.read<SearchPatientsCubit>().searchPatients(
          search: _searchQuery,
        );
      } else {
        context.read<GetAllPatientsCubit>().getAllPatients();
      }
    }
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (_searchQuery != value) {
        _searchQuery = value;
        if (value.isEmpty) {
          // Switch back to "get all" mode
          _isSearching = false;
          context.read<SearchPatientsCubit>().reset();
          context.read<GetAllPatientsCubit>().refresh();
        } else {
          // Switch to search mode
          _isSearching = true;
          context.read<SearchPatientsCubit>().searchPatients(search: value);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAllPatientsCubit, GetAllPatientsState>(
      builder: (context, getAllState) {
        return BlocBuilder<SearchPatientsCubit, SearchPatientsState>(
          builder: (context, searchState) {
            // Determine which data to show
            List<PatientData> patients = [];
            int totalPatients = 0;
            bool hasMore = false;
            bool isLoading = false;
            bool isError = false;
            String errorMessage = '';

            if (_isSearching) {
              if (searchState is SearchPatientsSuccess) {
                patients = searchState.patients;
                totalPatients = searchState.totalPatients;
                hasMore = searchState.hasMore;
              } else if (searchState is SearchPatientsLoading) {
                isLoading = true;
              } else if (searchState is SearchPatientsError) {
                isError = true;
                errorMessage = searchState.errorMessage.message ?? '';
              }
            } else {
              if (getAllState is GetAllPatientsSuccess) {
                patients = getAllState.patients;
                totalPatients = getAllState.totalPatients;
                hasMore = getAllState.hasMore;
              } else if (getAllState is GetAllPatientsLoading) {
                isLoading = true;
              } else if (getAllState is GetAllPatientsError) {
                isError = true;
                errorMessage = getAllState.errorMessage.message ?? '';
              }
            }

            return RefreshIndicator(
              color: AlNasTheme.blue100,
              onRefresh: _onRefresh,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  SliverPersistentHeader(
                    delegate: HomeHeaderDelegate(
                      expandedHeight: 310.h,
                      collapsedHeight: 180.h,
                      onSearchChanged: _onSearchChanged,
                      totalPatients: totalPatients,
                    ),
                    pinned: true,
                  ),
                  // Loading indicator for first page
                  if (isLoading && patients.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  // Error state
                  if (isError && patients.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48.sp,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              errorMessage.isNotEmpty
                                  ? errorMessage
                                  : S.of(context).somethingWentWrong,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton(
                              onPressed: () {
                                if (_isSearching) {
                                  context
                                      .read<SearchPatientsCubit>()
                                      .searchPatients(search: _searchQuery);
                                } else {
                                  context.read<GetAllPatientsCubit>().refresh();
                                }
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Empty state
                  if (!isLoading && !isError && patients.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 48.sp,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'No patients found',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Patient list
                  if (patients.isNotEmpty)
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          if (index < patients.length) {
                            final item = patients[index];
                            return PatientCard(
                              name: item.fullName ?? 'Unknown',
                              id: item.mrn ?? item.id.toString(),
                              type: item.specialty ?? 'Unknown',
                              reading: '---',
                              unit: S.of(context).mgDl,
                              status: PatientStatus.stable,
                              statusText: S.of(context).stable,
                            );
                          }
                          // Loading indicator at bottom
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }, childCount: patients.length + (hasMore ? 1 : 0)),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
