import 'package:bloc/bloc.dart';

import 'image_event.dart';
import 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  ImageBloc() : super(ImageBlocInitial()) {
    on<ImageEvent>((event, emit) {
      emit(ImageBlocInitial());
    });

    on<GetImageEvent>((event, emit) {
      print('-------isImageEvent--------${event.image}');
      emit(event.image == null
          ? GetImageDlt(image: event.image)
          : GetImageData(image: event.image));
    });
  }
}
