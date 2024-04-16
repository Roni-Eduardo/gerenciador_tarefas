

import 'package:flutter/material.dart';
import 'package:gerenciador_tarefas/dao/tarefa_dao.dart';
import 'package:gerenciador_tarefas/pages/filtro_pages.dart';
import 'package:gerenciador_tarefas/widgets/conteudo_form_dialog.dart';

import '../model/tarefa.dart';

class ListaTarefaPage extends StatefulWidget{

  @override
  _ListaTarefaPageState createState() => _ListaTarefaPageState();
}

class _ListaTarefaPageState extends State<ListaTarefaPage>{

  final _tarefas = <Tarefa>[];
  final _dao = TarefaDao();

  static const ACAO_EDITAR = 'editar';
  static const ACAO_EXCLUIR = 'excluir';

  @override
  @override
  void initstate(){
    super.initState();
    _atualizarLista();
  }

  Widget _criarBody(){
  if(_tarefas.isEmpty){
    return const Center(
      child: Text('Tudo certo por aqui!',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
    );

  }

  return ListView.separated(itemBuilder: (BuildContext context, int index){
    final tarefa = _tarefas[index];
    return PopupMenuButton<String>(
        child: ListTile(
          title: Text('${tarefa.id} - ${tarefa.descricao}'),
          subtitle: Text(tarefa. prazoFormatado == ''? 'Sem prazo definido' : 'Prazo - ${tarefa.prazoFormatado}'),
        ),
        itemBuilder: (BuildContext context) => criarItensMenuPopUp(),
      onSelected: (String valorSelecionado){
          if(valorSelecionado == ACAO_EDITAR){
            _abrirForm(tarefaAtual: tarefa);
          }else{
            _excluir(tarefa);
          }
      },
    );
  },
      separatorBuilder: (BuildContext context, int index) => const Divider(), itemCount: _tarefas.length,
  );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: _criarAppBar(context),
      body: _criarBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirForm,
        child: Icon(Icons.add),
        tooltip: 'Nova Tarefa',
      ),
    );
  }

  AppBar _criarAppBar(BuildContext context){
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      title: Text('Tarefas'), //cabeçalho
      centerTitle: false,
      actions: [
        IconButton(
            onPressed: _abrirFiltro,
            icon: Icon(Icons.filter_list),
        ) //IconButton
      ],
    ); //Appbar
  }

  void _abrirFiltro(){
    final navigator = Navigator.of(context);
    navigator.pushNamed(FiltroPage.ROUTE_NAME).then((alterouValor){
      if(alterouValor == true){
        //implementação de filtro
      }
    });
  }

  List<PopupMenuEntry<String>> criarItensMenuPopUp(){
    return [
     const PopupMenuItem(
        value: ACAO_EDITAR,
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.black),
              Padding(padding: EdgeInsets.only(left: 10),
                child: Text('Editar'),
              )
            ],
          )
      ),
      const PopupMenuItem(
          value: ACAO_EXCLUIR,
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              Padding(padding: EdgeInsets.only(left: 10),
                child: Text('Excluir'),
              )
            ],
          )
      )
    ];
  }

  Future _excluir(Tarefa tarefa){
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.red,),
              Padding(padding: EdgeInsets.only(left: 10),
                child: Text('Atenção'),
              )
            ],
          ),
          content: const Text('Esse registro será deleto definitivamente!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar')
            ),
            TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                  if(tarefa.id == null){
                    return;
                  }
                  _dao.remover(tarefa.id!).then((success){
                    if(success){
                      _atualizarLista();
                    }
                  });
                  },
                child: const Text('Ok')
            ),
          ],
        );
      }
    );
  }

  void _abrirForm({Tarefa? tarefaAtual}){
    final key = GlobalKey<ConteudoFormDialogState>();
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(tarefaAtual == null ? 'Nova tarefa' : 'Alterar Tarefa ${tarefaAtual.id}'),// Text
          content: ConteudoFormDialog(key: key, tarefaAtual: tarefaAtual),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancelar')),
              TextButton(onPressed: (){
                if (key.currentState!.dadosValidados() && key.currentState != null){
                  setState((){
                    final novaTarefa = key.currentState!.novaTarefa;
                    _dao.salvar(novaTarefa).then((success){
                      if(success){
                        _atualizarLista();
                      }
                    });
                  });
                  Navigator.of(context).pop();
                }
              }, child: Text('Salvar'),
            )
          ],
        );
      }
    );
  }

  void _atualizarLista() async{
    final tarefas = await _dao.Lista();
    setState(() {
      _tarefas.clear();
      if(tarefas.isNotEmpty){
        _tarefas.addAll(tarefas);
      }
    });
  }
}
