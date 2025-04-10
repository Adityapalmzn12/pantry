import 'package:bloc/bloc.dart';
import '../../../data/model/item/folder_model.dart';
import '../../../data/model/item/item.dart';
import '../../../data/repository/item_repository.dart';
import 'item_event.dart';
import 'item_state.dart';
import 'package:stream_transform/stream_transform.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ItemRepository repository;

  ItemBloc(this.repository) : super(ItemInitial()) {
    on<LoadFoldersAndItemsEvent>(_onLoadFoldersAndItems);
    on<AddFolderEvent>(_onAddFolder);
    on<AddItemEvent>(_onAddItem);
    on<UpdateItemQuantityEvent>(
      _onUpdateItemQuantity,
      transformer: debounce(const Duration(milliseconds: 200)),
    );
    on<DeleteItemEvent>(_onDeleteItem); // Add the DeleteItemEvent handler
  }

  // Debounce transformer
  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounce(duration).asyncExpand(mapper);
  }

  Future<void> _onLoadFoldersAndItems(
      LoadFoldersAndItemsEvent event, Emitter<ItemState> emit) async {
    emit(ItemLoading());

    try {
      final defaultFolders = await repository.getDefaultFolders();  // Default folders
      final storedFolders = await repository.getFolders();          // Folders saved in SharedPreferences
      final items = await repository.getItems();                    // Items associated with the folders

      // Merge the default folders with the stored folders, ensuring no duplicates by ID or name
      final mergedFolders = [
        ...storedFolders.where(
              (storedFolder) =>
          !defaultFolders.any(
                (defaultFolder) =>
            defaultFolder.id == storedFolder.id ||
                defaultFolder.name.toLowerCase() == storedFolder.name.toLowerCase(),
          ),
        ),
        ...defaultFolders, // Add default folders only if not already present
      ];

      emit(ItemLoaded(folders: mergedFolders, items: items));
    } catch (e) {
      emit(ItemError(e.toString()));
    }
  }




  Future<void> _onAddFolder(AddFolderEvent event, Emitter<ItemState> emit) async {
    final storedFolders = await repository.getFolders();

    // Check if the folder already exists based on the ID or name.
    final isAlreadyExists = storedFolders.any(
          (folder) => folder.id == event.folder.id || folder.name.toLowerCase() == event.folder.name.toLowerCase(),
    );

    if (!isAlreadyExists) {
      final updatedFolders = List<FolderModel>.from(storedFolders)..add(event.folder);
      await repository.saveFolders(updatedFolders);
    }

    // Emit the updated state with merged folders
    if (state is ItemLoaded) {
      final currentState = state as ItemLoaded;

      final defaultFolders = await repository.getDefaultFolders();
      final mergedFolders = [
        ...defaultFolders,
        ...storedFolders.where(
              (folder) => !defaultFolders.any((defaultFolder) => defaultFolder.id == folder.id),
        ),
      ];

      emit(ItemLoaded(folders: mergedFolders, items: currentState.items));
    }
  }




  Future<void> _onAddItem(AddItemEvent event, Emitter<ItemState> emit) async {
    if (state is ItemLoaded) {
      final currentState = state as ItemLoaded;
      final updatedItems = List<ItemModel>.from(currentState.items)..add(event.item);

      for (final item in updatedItems) {
        await repository.saveItem(item);
      }

      emit(ItemLoaded(folders: currentState.folders, items: updatedItems));
    }
  }

  Future<void> _onUpdateItemQuantity(
      UpdateItemQuantityEvent event,
      Emitter<ItemState> emit,
      ) async {
    if (state is ItemLoaded) {
      final currentState = state as ItemLoaded;

      final updatedItems = currentState.items.map((item) {
        if (item.id == event.itemId) {
          final newQuantity = (item.quantity + event.change).clamp(0, double.infinity).toInt();
          final updatedItem = item.copyWith(quantity: newQuantity);

          repository.saveItem(updatedItem); // Non-blocking save
          return updatedItem;
        }
        return item;
      }).toList();

      emit(ItemLoaded(folders: currentState.folders, items: updatedItems));
    }
  }

  // Fix: Handling the delete item event properly

  Future<void> _onDeleteItem(DeleteItemEvent event, Emitter<ItemState> emit) async {
    if (state is ItemLoaded) {
      final currentState = state as ItemLoaded;
      final updatedItems = currentState.items.where((item) => item.id != event.itemId).toList();

      try {
        // Remove the item from the repository
        await repository.deleteItem(event.itemId);

        // Emit updated state with the item removed
        emit(ItemLoaded(folders: currentState.folders, items: updatedItems));
      } catch (e) {
        emit(ItemError('Failed to delete item: $e'));
      }
    }
  }

}
