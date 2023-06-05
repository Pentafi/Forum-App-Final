from django.urls import path
from .views import MyTokenObtainPairView, register, user_login, user_logout, SectionCreateView, SectionListView, ForumCreateView, ForumListView, TopicCreateView, TopicListView, PostCreateView, PostListView, UserListView

urlpatterns = [
    path('register/', register),
    path('login/', MyTokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('logout/', user_logout),
    path('sections/', SectionListView.as_view()),
    path('sections/create/', SectionCreateView.as_view()),
    path('forums/', ForumListView.as_view()),
    path('forums/create/', ForumCreateView.as_view()),
    path('topics/', TopicListView.as_view()),
    path('topics/create/', TopicCreateView.as_view()),
    path('posts/', PostListView.as_view()),
    path('posts/create/', PostCreateView.as_view()),
    path('users/', UserListView.as_view()),
]
