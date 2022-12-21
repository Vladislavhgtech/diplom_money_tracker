import 'package:flutter_bloc/flutter_bloc.dart';

import '../states/costs_state.dart';
import '../../repositories/costs_repository.dart';
import '../events/costs_event.dart';

class CostsBloc extends Bloc<CostsEvent, CostsState> {
  final CostsRepository costsRepository;

  CostsBloc({required this.costsRepository})
      : super(CostsState(
            date: DateTime.now(),
            categories: const [],
            costs: const [],
            isLoading: true)) {
    on<SetDateRequested>((event, emit) async {
      await _onSetDate(event, emit);
    });
    on<UpdateDataRequested>((event, emit) async {
      await _onUpdateData(event, emit);
    });
    on<AddCategoryRequested>((event, emit) async {
      await _onAddCategory(event, emit);
    });
    on<AddCostRequested>((event, emit) async {
      await _onAddCost(event, emit);
    });
    on<FlagIsDeleteCategoryRequested>((event, emit) async {
      await _onFlagIsDeleteCategory(event, emit);
    });
    on<FlagIsDeleteCostRequested>((event, emit) async {
      await _onFlagIsDeleteCost(event, emit);
    });
    on<DeleteCategoryRequested>((event, emit) async {
      await _onDeleteCategory(event, emit);
    });
    on<DeleteCostRequested>((event, emit) async {
      await _onDeleteCost(event, emit);
    });
  }

  Future<void> _onSetDate(event, emit) async {
    await loadingState(event, emit);
    await costsRepository.setDate(event.date);
    await costsRepository.requestAllCategories();
    await costsRepository.requestAllCosts();
    await loadData(event, emit);
  }

  Future<void> _onUpdateData(event, emit) async {
    await costsRepository.requestAllCategories();
    await costsRepository.requestAllCosts();
    await loadData(event, emit);
  }

  Future<void> _onAddCategory(event, emit) async {
    await costsRepository.addCategory(event.name, event.color);
    await costsRepository.requestAllCategories();
    await costsRepository.requestAllCosts();
    await loadData(event, emit);
  }

  Future<void> _onAddCost(event, emit) async {
    await costsRepository.addCost(event.sum, event.date, event.category);
    await costsRepository.requestAllCategories();
    await costsRepository.requestAllCosts();
    await loadData(event, emit);
  }

  Future<void> _onFlagIsDeleteCategory(event, emit) async {
    await costsRepository.flagIsDeleteCategory(event.category);
    await costsRepository.requestAllCategories();
    await loadData(event, emit);
  }

  Future<void> _onFlagIsDeleteCost(event, emit) async {
    await costsRepository.flagIsDeleteCost(event.cost);
    await costsRepository.requestAllCosts();
    await loadData(event, emit);
  }

  Future<void> _onDeleteCategory(event, emit) async {
    await costsRepository.deleteCategory(event.category);
    await costsRepository.requestAllCategories();
    await costsRepository.requestAllCosts();
    await loadData(event, emit);
  }

  Future<void> _onDeleteCost(event, emit) async {
    await costsRepository.deleteCost(event.cost);
    await costsRepository.requestAllCosts();
    await loadData(event, emit);
  }

  Future<void> loadingState(event, emit) async {
    final date = await costsRepository.loadDate();
    final categories = await costsRepository.loadCategories();
    final costs = await costsRepository.loadCosts();

    emit(CostsState(
        date: date, categories: categories, costs: costs, isLoading: true));
  }

  Future<void> loadData(event, emit) async {
    final date = await costsRepository.loadDate();
    final categories = await costsRepository.loadCategories();
    final costs = await costsRepository.loadCosts();

    emit(CostsState(
        date: date, categories: categories, costs: costs, isLoading: false));
  }
}
