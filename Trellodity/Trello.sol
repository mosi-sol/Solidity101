pragma solidity 0.8;

contract Note {
    enum Stage { Staging, Review, Done }

    struct NoteItem {
        string title;
        string content;
        address author;
        uint timestamp;
        Stage stage;
    }

    mapping(uint => NoteItem) public notes;
    uint public noteCount;

    event NoteCreated(uint id, string title, address author, uint timestamp, Stage stage);
    event NoteStageChanged(uint id, Stage stage);

    function createNote(string memory _title, string memory _content) public {
        noteCount++;
        notes[noteCount] = NoteItem(_title, _content, msg.sender, block.timestamp, Stage.Staging);
        emit NoteCreated(noteCount, _title, msg.sender, block.timestamp, Stage.Staging);
    }

    function getNoteTitle(uint _id) public view returns (string memory) {
        return notes[_id].title;
    }

    function getNoteContent(uint _id) public view returns (string memory) {
        return notes[_id].content;
    }

    function getNoteAuthor(uint _id) public view returns (address) {
        return notes[_id].author;
    }

    function getNoteTimestamp(uint _id) public view returns (uint) {
        return notes[_id].timestamp;
    }

    function getNoteStage(uint _id) public view returns (Stage) {
        return notes[_id].stage;
    }

    function changeNoteStage(uint _id, Stage _stage) public {
        require(_stage != notes[_id].stage, "Note is already in this stage");
        notes[_id].stage = _stage;
        emit NoteStageChanged(_id, _stage);
    }
}
