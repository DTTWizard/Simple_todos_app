import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../models/todoModel.dart';
import 'package:uuid/uuid.dart';

class TodoRouter {
  // Danh sách todo
  final List<todoModel> _todos = [];
  static final _headers = {'Content-Type': 'application/json'};

  // Tạo và trả về router hoạt động CRUD
  Router get router {
    final router = Router();

    // Định nghĩa các route cho todo
    router.get('/todos', _getTodosHandle); // Lấy danh sách todo
    router.post('/todos', _addTodoHandle); // Thêm todo mới
    router.put('/todos/<id>', _updateTodoHandle); // Cập nhật todo
    router.delete('/todos/<id>', _deleteTodoHandle); // Xóa todo

    return router;
  }

  Future<Response> _getTodosHandle(Request request) async {
    try {
      // Chuyển danh sách todos thành chuỗi JSON
      final body = json.encode(_todos.map((todo) => todo.toMap()).toList());
      return Response.ok(body, headers: _headers);
    } catch (e) {
      return Response.internalServerError(
        body: json.encode({'error': e.toString()}),
        headers: _headers,
      );
    }
  }

  Future<Response> _addTodoHandle(Request request) async {
    try {
      final payload = await request.readAsString();
      final data = json.decode(payload);

      final newTodo = todoModel(
        id: _todos.isEmpty ? 1 : _todos.last.id + 1, // Tạo ID mới cho todo
        tenCv: data['tenCv'],
        complated: data['complated'] ?? false,
      );

      _todos.add(newTodo);
      return Response.ok(
        json.encode(newTodo.toMap()),
        headers: _headers,
      );
    } catch (e) {
      return Response.internalServerError(
        body: json.encode({'error': 'Thêm todo không thành công: ${e.toString()}'}),
        headers: _headers,
      );
    }
  }

  Future<Response> _updateTodoHandle(Request request, String id) async {
    try {
      final payload = await request.readAsString();
      final data = json.decode(payload);
      
      final index = _todos.indexWhere((todo) => todo.id.toString() == id);
      if (index == -1) {
        return Response.notFound(
          json.encode({'message': 'Todo không tìm thấy'}),
          headers: _headers,
        );
      }

      // Cập nhật thông tin todo
      _todos[index] = _todos[index].copyWith(
        tenCv: data['tenCv'] ?? _todos[index].tenCv,
        complated: data['complated'] ?? _todos[index].complated,
      );

      return Response.ok(
        json.encode(_todos[index].toMap()),
        headers: _headers,
      );
    } catch (e) {
      return Response.internalServerError(
        body: json.encode({'error': 'Cập nhật todo không thành công: ${e.toString()}'}),
        headers: _headers,
      );
    }
  }

  Future<Response> _deleteTodoHandle(Request request, String id) async {
    try {
      final index = _todos.indexWhere((todo) => todo.id.toString() == id);
      if (index == -1) {
        return Response.notFound(
          json.encode({'message': 'Todo không tìm thấy'}),
          headers: _headers,
        );
      }

      _todos.removeAt(index); // Xóa todo
      return Response.ok(
        json.encode({'message': 'Todo đã bị xóa'}),
        headers: _headers,
      );
    } catch (e) {
      return Response.internalServerError(
        body: json.encode({'error': 'Xóa todo không thành công: ${e.toString()}'}),
        headers: _headers,
      );
    }
  }
}
