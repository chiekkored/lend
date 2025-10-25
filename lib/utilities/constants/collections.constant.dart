enum LNDCollections {
  users('users'),
  userChats('userChats'),
  chats('chats'),
  messages('messages'),
  assets('assets'),
  dates('dates'),
  bookings('bookings');

  final String name;
  const LNDCollections(this.name);
}
